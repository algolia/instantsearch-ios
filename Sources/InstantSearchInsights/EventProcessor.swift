//
//  EventProcessor.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
#if os(iOS)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

class EventProcessor: EventProcessable {
  
  typealias Storage = LocalStorage<[EventsPackage]>
  
  var eventsPackages: [EventsPackage]
  let eventsService: EventsService
  let logger: Logger
  let timerController: TimerController
  var isLocalStorageEnabled: Bool = true {
    didSet {
      if !isLocalStorageEnabled {
        Storage.deleteFile(atPath: localStorageFileName)
      }
    }
  }
  
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
  
  private let dispatchQueue: DispatchQueue
  private let localStorageFileName: String
  
  init(eventGroupingID: String,
       eventsService: EventsService,
       flushDelay: TimeInterval,
       logger: Logger,
       dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
    self.eventsPackages = []
    self.eventsService = eventsService
    self.logger = logger
    self.dispatchQueue = dispatchQueue
    //TODO: find a way to distinguish local storages per application
    self.localStorageFileName = "\(eventGroupingID).storage.events"
    self.timerController = TimerController(delay: flushDelay)
    readEventPackagesFromDisk()
    timerController.action = flushEventsPackages
    timerController.setup()
    
    let notificationName: Notification.Name?
    
    #if os(iOS)
    notificationName = UIApplication.willResignActiveNotification
    #elseif canImport(AppKit)
    notificationName = NSApplication.willResignActiveNotification
    #else
    notificationName = nil
    #endif
    
    if let notificationName = notificationName {
      NotificationCenter.default.addObserver(self, selector: #selector(flushEventsPackages), name: notificationName, object: .none)
    }
    
  }
  
  @objc func flushEventsPackages() {
    if eventsPackages.isEmpty {
      logger.debug(message: "No pending event packages")
    } else {
      logger.debug(message: "Flushing pending \(eventsPackages.count) event packages")
      eventsPackages.forEach(sync)
    }
  }
  
  func process(_ event: InsightsEvent) {
    guard isActive else {
      logger.debug(message: "Event tracking is desactivated. This event will be ignored. You can reactivate tracking by setting `Insights.shared(appId: %appId))`.isActive = true`")
      return
    }
    
    dispatchQueue.async { [weak self] in
      self?.syncProcess(event)
    }
  }
  
  private func syncProcess(_ event: InsightsEvent) {
    let eventsPackage: EventsPackage
    
    if let lastEventsPackage = eventsPackages.last, !lastEventsPackage.isFull {
      eventsPackage = (try? eventsPackages.removeLast().appending(event)) ?? EventsPackage(event: event)
    } else {
      eventsPackage = EventsPackage(event: event)
    }
    
    eventsPackages.append(eventsPackage)
    storeEventPackagesOnDisk()
  }
  
  private func remove(_ eventsPackage: EventsPackage) {
    //TODO: sync access
    eventsPackages.removeAll(where: { $0.id == eventsPackage.id })
    storeEventPackagesOnDisk()
  }
  
  private func sync(_ eventsPackage: EventsPackage) {
    logger.debug(message: "Syncing \(eventsPackage)")
    
    eventsService.sendEvents(eventsPackage.events) { [weak self]  result in
      // If there is no error or the error is from the Analytics we should remove it.
      // In case of a WebserviceError the package was wronlgy constructed
      switch result {
      case .success:
        self?.remove(eventsPackage)
      case .failure(let error as HTTPError) where (400..<500).contains(error.statusCode):
        self?.remove(eventsPackage)
      default:
        break
      }
    }
  }
  
  private func storeEventPackagesOnDisk() {
    guard isLocalStorageEnabled else { return }
    
    guard let filePath = Storage.filePath(for: localStorageFileName) else {
      logger.debug(message: "Error creating a file for \(localStorageFileName)")
      return
    }
    
    Storage.serialize(eventsPackages, file: filePath)
  }
  
  private func readEventPackagesFromDisk() {
    guard isLocalStorageEnabled else { return }
    
    guard let filePath = Storage.filePath(for: localStorageFileName) else {
      logger.debug(message: "Error reading a file for \(localStorageFileName)")
      return
    }
    
    self.eventsPackages = Storage.deserialize(filePath) ?? []
  }
  
}

extension EventProcessor: Flushable {
  
  var flushDelay: TimeInterval {
    get {
      return timerController.delay
    }
    
    set {
      timerController.delay = newValue
    }
  }
  
  func flush() {
    flushEventsPackages()
  }
  
}

