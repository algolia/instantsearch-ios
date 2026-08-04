//
//  EventProcessor.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// EventProcessor
/// - Storing of the events in the persistent storage (if provided)
/// - Forming the bounded packages of the events
/// – Synchronizing the events with a provided Service
class EventProcessor<Service: EventsService, PackageStorage: Storage>: Flushable, PackageManageable where PackageStorage.Item == [Package<Service.Event>] {
  public typealias Event = Service.Event

  /// The service to sync the events with
  let service: Service

  /// The logic forming the packages of events
  var packager: Packager<Event>

  /// The Storage keeping the packages of events
  let storage: PackageStorage?

  /// The controller emiting reccurrent flush event
  let timerController: TimerController

  /// Logging component
  var logger: Logger

  /// Closure filttering events before synchronizing them with the service
  let acceptEvent: (Event) -> Bool

  /// Whether events must be sent when the timer fires
  var isActive: Bool = true {
    didSet {
      switch (isActive, timerController.isActive) {
      case (true, false):
        timerController.setup()
      case (false, true):
        timerController.invalidate()
      default:
        return
      }
    }
  }

  /// Delay between stored sending events
  var flushDelay: TimeInterval {
    get {
      return timerController.delay
    }

    set {
      timerController.delay = newValue
    }
  }

  /// Maximal number of failed sync attempts for a package before it is dropped
  let maxRetryCount: Int

  /// Upper bound of the exponential backoff delay between sync attempts of a failed package
  let maxRetryBackoff: TimeInterval

  /// The delay after which a stored package is discarded without sending
  let packageExpirationDelay: TimeInterval

  /// Identifiers of the packages currently being synchronized with the service.
  /// Must only be accessed from the dispatchQueue.
  private var inFlightPackageIDs: Set<String> = []

  /// Count of failed sync attempts per package identifier.
  /// Must only be accessed from the dispatchQueue.
  private var retryCounts: [String: Int] = [:]

  /// Earliest allowed date of the next sync attempt per package identifier.
  /// Must only be accessed from the dispatchQueue.
  private var nextAttemptDates: [String: Date] = [:]

  /// The queue synchronizing the access to a packager
  private let dispatchQueue: DispatchQueue

  /**
    - Parameters:
      - service: Service to sync the events with
      - storage: Storage keeping the packages of events
      - packageCapacity: Capacity of each package
      - flushNotificationName: The name of the notification triggering the events flushing
      - flushDelay: The delay between recurrent events flushing
      - acceptEvent: Closure filttering events before synchronizing them with the service
      - maxRetryCount: Maximal number of failed sync attempts for a package before it is dropped
      - maxRetryBackoff: Upper bound of the exponential backoff delay between sync attempts of a failed package
      - packageExpirationDelay: The delay after which a stored package is discarded without sending
      - logger: Logging component
      - dispatchQueue: The queue synchronizing the access to event packages
   */
  init(service: Service,
       storage: PackageStorage?,
       packageCapacity: Int,
       flushNotificationName: Notification.Name?,
       flushDelay: TimeInterval,
       acceptEvent: @escaping (Event) -> Bool = { _ in true },
       maxRetryCount: Int = Algolia.Insights.maxRetryCount,
       maxRetryBackoff: TimeInterval = Algolia.Insights.maxRetryBackoff,
       packageExpirationDelay: TimeInterval = Algolia.Insights.packageExpirationDelay,
       logger: Logger,
       dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
    self.maxRetryCount = maxRetryCount
    self.maxRetryBackoff = maxRetryBackoff
    self.packageExpirationDelay = packageExpirationDelay
    packager = .init(packageCapacity: packageCapacity)
    self.storage = storage
    self.logger = logger
    let initialPackages: [Package<Event>]
    if let storage = storage {
      do {
        initialPackages = try storage.load()
      } catch {
        logger.debug("\(error)")
        initialPackages = []
      }
    } else {
      initialPackages = []
    }
    packager.set(initialPackages)
    self.service = service
    self.dispatchQueue = dispatchQueue
    timerController = TimerController(delay: flushDelay)
    self.acceptEvent = acceptEvent
    timerController.action = flush
    timerController.setup()
    InstantSearchInsightsLog.subscribeForLogLevelChange { [weak self] logLevel in
      self?.logger.logLevel = logLevel
    }
    if let flushNotificationName = flushNotificationName {
      NotificationCenter.default.addObserver(self, selector: #selector(flush), name: flushNotificationName, object: .none)
    }
  }

  func setPackageCapacity(_ capacity: Int) {
    packager = Packager(packages: packager.packages,
                        packageCapacity: capacity)
  }

  /// Process a new event
  /// - Parameter event: an event to process
  func process(_ event: Event) {
    guard isActive else {
      logger.info("Event tracking is desactivated. This event will be ignored. You can reactivate tracking by setting `Insights.shared(appId:)`.isActive = true`")
      return
    }

    dispatchQueue.async { [weak self] in
      guard let processor = self else { return }
      // Appending to a package changes its identifier: for a package awaiting a service
      // response this would make its removal on success impossible, leading to duplicate
      // sends, and for a failed package it would reset its backoff and retry count
      processor.packager.pack(event, sealedPackageIDs: processor.inFlightPackageIDs.union(processor.retryCounts.keys))
      let updatedPackages = processor.packager.packages
      do {
        try processor.storage?.store(updatedPackages)
      } catch {
        processor.logger.error("\(error.localizedDescription)")
      }
      if let lastPackage = processor.packager.packages.last, lastPackage.isFull {
        processor.flush()
      }
    }
  }

  /// Send all the stored events to the service
  @objc func flush() {
    dispatchQueue.async { [weak self] in
      guard let processor = self else { return }

      let now = Date()

      let expiredPackages = processor.packager.packages.filter { package in
        !processor.inFlightPackageIDs.contains(package.id) &&
          now.timeIntervalSince(package.creationDate) > processor.packageExpirationDelay
      }
      if !expiredPackages.isEmpty {
        processor.logger.error("dropping \(expiredPackages.count) event packages older than \(processor.packageExpirationDelay)s")
        processor.remove(expiredPackages)
      }

      let eventsPackages = processor.packager.packages.filter { package in
        guard !processor.inFlightPackageIDs.contains(package.id) else {
          return false
        }
        guard let nextAttemptDate = processor.nextAttemptDates[package.id] else {
          return true
        }
        return nextAttemptDate <= now
      }
      if eventsPackages.isEmpty {
        processor.logger.info("no pending event packages, skip flushing")
      } else {
        processor.logger.info("flushing pending \(eventsPackages.count) event packages")
        eventsPackages.forEach { processor.inFlightPackageIDs.insert($0.id) }
        eventsPackages.forEach(processor.sync)
      }
    }
  }
}

private extension EventProcessor {
  /// Synchronize a package with the service. Must be called from the dispatchQueue,
  /// with the package identifier already marked as in-flight.
  func sync(_ eventsPackage: Package<Event>) {
    logger.info("sending events package: \(eventsPackage.items)")

    let eligibleEvents = eventsPackage.items.filter(acceptEvent)

    guard !eligibleEvents.isEmpty else {
      logger.info("all events in package were filtered out by the acceptance condition, no event will be sent")
      inFlightPackageIDs.remove(eventsPackage.id)
      remove([eventsPackage])
      return
    }

    service.sendEvents(eligibleEvents) { [weak self] result in

      guard let processor = self else { return }

      processor.dispatchQueue.async {
        processor.inFlightPackageIDs.remove(eventsPackage.id)

        switch result {
        case .success:
          processor.logger.info("package succesfully sent")
          processor.remove([eventsPackage])

        case let .failure(error) where !Service.isRetryable(error):
          processor.logger.error("package sending failed: \(error.localizedDescription), the package won't be retried")
          processor.remove([eventsPackage])

        case let .failure(error):
          let retryCount = (processor.retryCounts[eventsPackage.id] ?? 0) + 1
          guard retryCount < processor.maxRetryCount else {
            processor.logger.error("package sending failed \(retryCount) times: \(error.localizedDescription), dropping the package")
            processor.remove([eventsPackage])
            return
          }
          processor.retryCounts[eventsPackage.id] = retryCount
          let backoff = min(processor.flushDelay * pow(2, Double(retryCount - 1)), processor.maxRetryBackoff)
          processor.nextAttemptDates[eventsPackage.id] = Date().addingTimeInterval(backoff)
          processor.logger.error("package sending failed: \(error.localizedDescription), next attempt in \(backoff)s")
        }
      }
    }
  }

  /// Remove packages and their retry bookkeeping. Must be called from the dispatchQueue.
  func remove(_ eventsPackages: [Package<Event>]) {
    for eventsPackage in eventsPackages {
      packager.remove(eventsPackage)
      retryCounts.removeValue(forKey: eventsPackage.id)
      nextAttemptDates.removeValue(forKey: eventsPackage.id)
    }
    let updatedPackages = packager.packages
    do {
      try storage?.store(updatedPackages)
    } catch {
      logger.error("\(error.localizedDescription)")
    }
  }
}
