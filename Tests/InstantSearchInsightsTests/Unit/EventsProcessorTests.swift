//
//  EventsProcessorTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

@testable import InstantSearchInsights
import XCTest

private struct TestError: Error {}

/// Service capturing completion handlers without invoking them, simulating in-flight requests
private class HoldingEventService<Event>: EventsService {
  var sentEvents: [[Event]] = []
  var pendingCompletions: [(Result<Void, Error>) -> Void] = []

  func sendEvents(_ events: [Event], completion: @escaping (Result<Void, Error>) -> Void) {
    sentEvents.append(events)
    pendingCompletions.append(completion)
  }

  static func isRetryable(_: Error) -> Bool {
    return true
  }
}

/// Service immediately failing with a retryable error
private class FailingEventService<Event>: EventsService {
  var sendCount = 0
  var didSendEvents: ([Event]) -> Void = { _ in }

  func sendEvents(_ events: [Event], completion: @escaping (Result<Void, Error>) -> Void) {
    sendCount += 1
    didSendEvents(events)
    completion(.failure(TestError()))
  }

  static func isRetryable(_: Error) -> Bool {
    return true
  }
}

/// Service immediately failing with a non-retryable error
private class NonRetryableFailingEventService<Event>: EventsService {
  var sendCount = 0

  func sendEvents(_: [Event], completion: @escaping (Result<Void, Error>) -> Void) {
    sendCount += 1
    completion(.failure(TestError()))
  }

  static func isRetryable(_: Error) -> Bool {
    return false
  }
}

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

  func testInFlightPackageIsNotResent() {
    let service = HoldingEventService<String>()
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")
    queue.sync {}

    eventsProcessor.flush()
    eventsProcessor.flush()
    eventsProcessor.flush()
    queue.sync {}

    XCTAssertEqual(service.sentEvents.count, 1, "a package awaiting a service response must not be sent again")
  }

  func testEventProcessedDuringSyncIsNotAppendedToInFlightPackage() {
    let service = HoldingEventService<String>()
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("first")
    queue.sync {}
    eventsProcessor.flush()
    queue.sync {}

    eventsProcessor.process("second")
    queue.sync {}
    XCTAssertEqual(eventsProcessor.packager.packages.count, 2, "an event tracked during a sync must start a new package")

    service.pendingCompletions.first?(.success(()))
    queue.sync {}
    queue.sync {}

    XCTAssertEqual(eventsProcessor.packager.packages.map(\.items), [["second"]], "the sent package must be removed, the new one kept")
  }

  func testRetryableFailureBacksOff() {
    let service = FailingEventService<String>()
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")
    queue.sync {}

    eventsProcessor.flush()
    queue.sync {}
    queue.sync {}

    eventsProcessor.flush()
    queue.sync {}

    XCTAssertEqual(service.sendCount, 1, "a failed package must not be retried before its backoff delay expires")
    XCTAssertEqual(eventsProcessor.packager.packages.count, 1, "a retryable package must be kept")
  }

  func testPackageDroppedAfterMaxRetryCount() {
    let exp = expectation(description: "two sync attempts")
    exp.expectedFulfillmentCount = 2

    let service = FailingEventService<String>()
    service.didSendEvents = { _ in exp.fulfill() }
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 0.1,
                                         maxRetryCount: 2,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")

    waitForExpectations(timeout: 5, handler: nil)
    queue.sync {}
    XCTAssertTrue(eventsProcessor.packager.packages.isEmpty, "the package must be dropped once the retry count is exhausted")
  }

  func testNonRetryableFailureRemovesPackage() {
    let service = NonRetryableFailingEventService<String>()
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")
    queue.sync {}

    eventsProcessor.flush()
    queue.sync {}
    queue.sync {}

    eventsProcessor.flush()
    queue.sync {}

    XCTAssertEqual(service.sendCount, 1)
    XCTAssertTrue(eventsProcessor.packager.packages.isEmpty)
  }

  func testFullyFilteredPackageIsRemoved() throws {
    let service = HoldingEventService<Int>()
    let queue = DispatchQueue(label: "test queue")

    let storage = TestPackageStorage<Int>()
    storage.store([try .init(items: [1, 3], capacity: 2)])

    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         acceptEvent: { $0 % 2 == 0 },
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.flush()
    queue.sync {}

    XCTAssertTrue(service.sentEvents.isEmpty)
    XCTAssertTrue(eventsProcessor.packager.packages.isEmpty, "a package whose events are all filtered out must be removed")
  }

  func testExpiredPackageIsDroppedWithoutSending() {
    let service = HoldingEventService<String>()
    let queue = DispatchQueue(label: "test queue")
    let eventsProcessor = EventProcessor(service: service,
                                         storage: storage,
                                         packageCapacity: 10,
                                         flushNotificationName: nil,
                                         flushDelay: 1000,
                                         packageExpirationDelay: 0.05,
                                         logger: Logger(label: #function),
                                         dispatchQueue: queue)

    eventsProcessor.process("Test event")
    queue.sync {}

    Thread.sleep(forTimeInterval: 0.2)

    eventsProcessor.flush()
    queue.sync {}

    XCTAssertTrue(service.sentEvents.isEmpty, "an expired package must not be sent")
    XCTAssertTrue(eventsProcessor.packager.packages.isEmpty, "an expired package must be removed")
  }
}
