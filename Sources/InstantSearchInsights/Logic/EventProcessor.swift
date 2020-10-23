//
//  EventProcessor.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// EventProcessor
/// - Storing of the events in the persistent storage (if provided)
/// - Forming the bounded packages of the events
/// – Synchronizing the events with a provided Service
class EventProcessor<Event, Service: EventsService, PackageStorage: Storage>: Flushable where Service.Event == Event,
                                                                                              PackageStorage.Item == [Package<Event>] {

  /// The service to sync the events with
  let service: Service

  /// The logic forming the packages of events
  var packager: Packager<Event>

  /// The Storage keeping the packages of events
  let storage: PackageStorage?

  /// The controller emiting reccurrent flush event
  let timerController: TimerController

  /// Logging component
  let logger: PrefixedLogger

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

  /// The queue synchronizing the access to a packager
  private let dispatchQueue: DispatchQueue

  /**
    - Parameters:
      - service: Service to sync the events with
      - storage: Storage keeping the packages of events
      - packageCapacity: Capacity of each package
      - flushNotificationName: The name of the notification triggering the events flushing
      - flushDelay: The delay between recurrent events flushing
      - logger: Logging component
      - dispatchQueue: The queue synchronizing the access to event packages
   */
  init(service: Service,
       storage: PackageStorage?,
       packageCapacity: Int,
       flushNotificationName: Notification.Name?,
       flushDelay: TimeInterval,
       logger: PrefixedLogger,
       dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {

    self.packager = .init(packageCapacity: packageCapacity)
    self.storage = storage
    self.logger = logger
    let initialPackages: [Package<Event>]
    if let storage = storage {
      do {
        initialPackages = try storage.load()
      } catch let error {
        logger.debug("\(error)")
        initialPackages = []
      }
    } else {
      initialPackages = []
    }
    self.packager.set(initialPackages)
    self.service = service
    self.dispatchQueue = dispatchQueue
    self.timerController = TimerController(delay: flushDelay)
    timerController.action = flush
    timerController.setup()
    if let flushNotificationName = flushNotificationName {
      NotificationCenter.default.addObserver(self, selector: #selector(flush), name: flushNotificationName, object: .none)
    }
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
      processor.packager.pack(event)
      let updatedPackages = processor.packager.packages
      do {
        try processor.storage?.store(updatedPackages)
      } catch let error {
        processor.logger.error(error)
      }
    }
  }

  /// Send all the stored events to the service
  @objc func flush() {
    dispatchQueue.async { [weak self] in
      guard let processor = self else { return }
      let eventsPackages = processor.packager.packages
      if eventsPackages.isEmpty {
        processor.logger.info("no pending event packages, skip flushing")
      } else {
        processor.logger.info("flushing pending \(eventsPackages.count) event packages")
        eventsPackages.forEach(processor.sync)
      }
    }
  }

}

private extension EventProcessor {

  func sync(_ eventsPackage: Package<Event>) {
    logger.info("sending events package: \(eventsPackage.items)")

    service.sendEvents(eventsPackage.items) { [weak self]  result in

      guard let processor = self else { return }

      let shouldRemovePackage: Bool

      switch result {
      case .success:
        processor.logger.info("package succesfully sent")
        shouldRemovePackage = true
      case .failure(let error):
        processor.logger.error("package sending failed: \(error.localizedDescription)")
        shouldRemovePackage = !Service.isRetryable(error)
      }

      guard shouldRemovePackage else { return }

      processor.dispatchQueue.async {
        processor.packager.remove(eventsPackage)
        let updatedPackages = processor.packager.packages
        do {
          try processor.storage?.store(updatedPackages)
        } catch let error {
          processor.logger.error(error)
        }
      }

    }
  }

}
