//
//  EventTrackerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

@testable import InstantSearchInsights
import XCTest

class EventTrackerTests: XCTestCase {
  let eventProcessor = TestEventProcessor()
  var eventTracker: EventTracker!

  override func setUp() {
    eventTracker = EventTracker(eventProcessor: eventProcessor,
                                logger: Logger(label: "EventTrackerTests"),
                                userToken: .none,
                                generateTimestamps: true)
  }

  func testViewEventWithObjects() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .viewedObjectIDs)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.objectIDs, TestEvent.objectIDs)
      XCTAssertNil(event.filters)
      exp.fulfill()
    }

    eventTracker.view(eventName: TestEvent.eventName,
                      indexName: TestEvent.indexName,
                      userToken: TestEvent.userToken,
                      timestamp: TestEvent.timeStamp,
                      objectIDs: TestEvent.objectIDs)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testViewEventWithFilters() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .viewedFilters)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.filters, FilterFacet.parseFilters(TestEvent.filters))
      XCTAssertNil(event.objectIDs)
      exp.fulfill()
    }

    eventTracker.view(eventName: TestEvent.eventName,
                      indexName: TestEvent.indexName,
                      userToken: TestEvent.userToken,
                      timestamp: TestEvent.timeStamp,
                      filters: TestEvent.filters)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testClickEventWithObjects() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .clickedObjectIDs)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.objectIDs, TestEvent.objectIDs)
      XCTAssertNil(event.filters)
      exp.fulfill()
    }

    eventTracker.click(eventName: TestEvent.eventName,
                       indexName: TestEvent.indexName,
                       userToken: TestEvent.userToken,
                       timestamp: TestEvent.timeStamp,
                       objectIDs: TestEvent.objectIDs)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testClickEventWithFilters() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .clickedFilters)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.filters, FilterFacet.parseFilters(TestEvent.filters))
      XCTAssertNil(event.objectIDs)
      exp.fulfill()
    }

    eventTracker.click(eventName: TestEvent.eventName,
                       indexName: TestEvent.indexName,
                       userToken: TestEvent.userToken,
                       timestamp: TestEvent.timeStamp,
                       filters: TestEvent.filters)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConversionEventWithObjects() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .convertedObjectIDs)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.objectIDs, TestEvent.objectIDs)
      XCTAssertNil(event.filters)
      exp.fulfill()
    }

    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            userToken: TestEvent.userToken,
                            timestamp: TestEvent.timeStamp,
                            objectIDs: TestEvent.objectIDs)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConversionEventWithFilters() {
    let exp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertEqual(event.eventType, .convertedFilters)
      XCTAssertEqual(event.indexName, TestEvent.indexName)
      XCTAssertEqual(event.eventName, TestEvent.eventName)
      XCTAssertEqual(event.userToken, TestEvent.userToken)
      XCTAssertNil(event.queryID)
      XCTAssertEqual(event.filters, FilterFacet.parseFilters(TestEvent.filters))
      XCTAssertNil(event.objectIDs)
      exp.fulfill()
    }

    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            userToken: TestEvent.userToken,
                            timestamp: TestEvent.timeStamp,
                            filters: TestEvent.filters)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testTimeStampGeneration() {
    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: Logger(label: "EventTrackerTests"),
                                    userToken: .none,
                                    generateTimestamps: true)

    let expectGeneratedTimeStamp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertNotNil(event.timestamp)
      expectGeneratedTimeStamp.fulfill()
    }

    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            timestamp: nil,
                            filters: TestEvent.filters)

    waitForExpectations(timeout: 5, handler: nil)

    eventTracker.generateTimestamps = false

    let expectEmptyTimestamp = expectation(description: "Wait for event processor callback")

    eventProcessor.didProcess = { event in
      XCTAssertNil(event.timestamp)
      expectEmptyTimestamp.fulfill()
    }

    eventTracker.conversion(eventName: TestEvent.eventName,
                            indexName: TestEvent.indexName,
                            timestamp: nil,
                            filters: TestEvent.filters)

    waitForExpectations(timeout: 5, handler: nil)
  }
}
