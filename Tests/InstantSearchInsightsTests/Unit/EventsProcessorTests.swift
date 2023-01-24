//
//  EventsProcessorTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import AlgoliaSearchClient
@testable import InstantSearchInsights
import XCTest

class EventsProcessorTests: XCTestCase {
  var storage: TestPackageStorage<String> { return .init() }

  func testOptOut() {
    let exp = expectation(description: "service response")
    exp.isInverted = true

    let mockService = MockEventService<String> { _ in
      exp.fulfill()
    }

    let packageCapacity = 10

    let queue = DispatchQueue(label: "test queue", qos: .default)
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    // Expectation must no be fullfilled as eventsProcessor is deactivated

    eventsProcessor.isActive = false
    eventsProcessor.process("TestEvent")
    queue.sync {}
    XCTAssertTrue(eventsProcessor.packager.packages.isEmpty)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testOptOutOptIn() {
    let exp = expectation(description: "service response")

    let mockService = MockEventService<String> { _ in
      exp.fulfill()
    }

    let packageCapacity = 10

    let queue = DispatchQueue(label: "test queue", qos: .default)
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.isActive = false
    eventsProcessor.isActive = true
    eventsProcessor.process("Test event")
    queue.sync {}
    XCTAssertFalse(eventsProcessor.packager.packages.isEmpty)
    eventsProcessor.flush()
    waitForExpectations(timeout: 5, handler: nil)
  }

  func testPackageAssembly() {
    let mockService = MockEventService<String>()

    let packageCapacity = 10

    let queue = DispatchQueue(label: "test queue", qos: .default)
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")

    queue.sync {}
    XCTAssertEqual(eventsProcessor.packager.packages.count, 1)

    eventsProcessor.process("Test event")

    queue.sync {}

    XCTAssertEqual(eventsProcessor.packager.packages.count, 1)
    XCTAssertEqual(eventsProcessor.packager.packages.first?.items.count, 2)

    let events = [String](repeating: "Test event", count: packageCapacity)

    events.forEach(eventsProcessor.process)

    queue.sync {}

    XCTAssertEqual(eventsProcessor.packager.packages.count, 2)
    XCTAssertEqual(eventsProcessor.packager.packages.first?.count, packageCapacity)
    XCTAssertEqual(eventsProcessor.packager.packages.last?.count, 2)
  }

  func testSync() {
    let exp = expectation(description: "service response")

    let mockService = MockEventService<String> { _ in exp.fulfill() }
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")
    queue.sync {}
    eventsProcessor.flush()

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testFlushOnTimer() {
    let exp = expectation(description: "service response")
    let mockService = MockEventService<String> { _ in exp.fulfill() }
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 2,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")

    waitForExpectations(timeout: 4, handler: nil)
  }

  func testFlushOnNotification() {
    let flushNotificationName: Notification.Name = .init("Test Notification")
    let exp = expectation(description: "service response")
    let mockService = MockEventService<String> { _ in exp.fulfill() }
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: flushNotificationName,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")

    NotificationCenter.default.post(name: flushNotificationName, object: nil)

    waitForExpectations(timeout: 4, handler: nil)
  }

  func testStorageExchange() throws {
    let mockService = MockEventService<String>()
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")

    let storage = TestPackageStorage<String>()
    storage.store([try .init(items: ["1", "2"], capacity: 2), try .init(items: ["3", "4"], capacity: 2)])

    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("5")
    queue.sync {}
    XCTAssertEqual(storage.load().map(\.items), [["1", "2"], ["3", "4"], ["5"]])
  }

  func testEventsFiltering() throws {
    let mockService = MockEventService<Int>()
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")

    let storage = TestPackageStorage<Int>()
    storage.store([try .init(items: [1, 2], capacity: 2), try .init(items: [3, 4], capacity: 2)])

    let acceptEvent: (Int) -> Bool = { $0 % 2 == 0 }

    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         acceptEvent: acceptEvent,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    let exp = expectation(description: "send events")
    exp.expectedFulfillmentCount = 2

    mockService.didSendEvents = { events in
      XCTAssertTrue(events.allSatisfy(acceptEvent))
      exp.fulfill()
    }

    eventsProcessor.flush()

    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testEventsFilteringException() throws {
    let mockService = MockEventService<Int>()
    let packageCapacity = 10
    let queue = DispatchQueue(label: "test queue")
    
    let storage = TestPackageStorage<Int>()
    storage.store([try .init(items: [1, 2], capacity: 2), try .init(items: [3, 4], capacity: 2)])

    let acceptEvent: (Int) -> Bool = { _ in false }
    
    
    let eventsProcessor = EventProcessor(service: mockService,
                                         storage: storage,
                                         packageCapacity: packageCapacity,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         acceptEvent: acceptEvent,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    let exp = expectation(description: "send events")
    exp.isInverted = true
    
    mockService.didSendEvents = { events in
      XCTAssertTrue(events.allSatisfy(acceptEvent))
      exp.fulfill()
    }
    
    eventsProcessor.flush()
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}
