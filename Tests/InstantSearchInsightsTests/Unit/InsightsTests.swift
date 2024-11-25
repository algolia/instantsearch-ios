//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Search
@testable import InstantSearchInsights
import XCTest

class InsightsTests: XCTestCase {
  let appID: ApplicationID = "test app id"
  let apiKey: APIKey = "test key"
  let testEventTracker = TestEventTracker()
  let testEventProcessor = TestEventProcessor()
  lazy var testInsights: Insights = .init(eventProcessor: testEventProcessor, eventTracker: testEventTracker, logger: Logger(label: "InsightsTest"))

  func testInitShouldFail() {
    let insightsRegister = Insights.shared(appId: "test")
    XCTAssertNil(insightsRegister)

    Insights.register(appId: "app1", apiKey: "key1")
    Insights.register(appId: "app2", apiKey: "key2")

    XCTAssertNil(Insights.shared)
  }

  func testInitShouldWork() {
    let insightsRegister = Insights.register(appId: appID, apiKey: apiKey)
    XCTAssertNotNil(insightsRegister)

    let insightsShared = Insights.shared(appId: appID)
    XCTAssertNotNil(insightsShared)

    XCTAssertTrue(insightsRegister === insightsShared, "Getting the Insights instance from register and shared must be the same")
  }

  func testOptIntOptOut() {
    let insightsRegister = Insights.register(appId: appID, apiKey: apiKey)

    XCTAssertTrue(insightsRegister.eventProcessor.isActive)
    insightsRegister.isActive = false
    XCTAssertFalse(insightsRegister.eventProcessor.isActive)
  }

  func testClickInSearch() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 3

    testEventTracker.didClickObjectsAfterSearch = { _, indexName, userToken, _, objectIDs, positions, queryID in
      exp.fulfill()
      XCTAssertEqual(TestEvent.queryID, queryID)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      XCTAssertEqual(objectIDs.count, positions.count)
      if objectIDs.count > 1 {
        XCTAssertEqual(TestEvent.objectIDs, objectIDs)
        XCTAssertEqual(TestEvent.positions, positions)
      } else {
        XCTAssertEqual(TestEvent.objectIDs.first, objectIDs.first)
        XCTAssertEqual(TestEvent.positions.first, positions.first)
      }
    }

    testInsights.clickedAfterSearch(eventName: TestEvent.eventName,
                                    indexName: TestEvent.indexName,
                                    objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                    queryID: TestEvent.queryID,
                                    userToken: TestEvent.userToken)

    testInsights.clickedAfterSearch(eventName: TestEvent.eventName,
                                    indexName: TestEvent.indexName,
                                    objectIDs: TestEvent.objectIDs,
                                    positions: TestEvent.positions,
                                    queryID: TestEvent.queryID,
                                    userToken: TestEvent.userToken)

    testInsights.clickedAfterSearch(eventName: TestEvent.eventName,
                                    indexName: TestEvent.indexName,
                                    objectID: TestEvent.objectIDs.first!,
                                    position: TestEvent.positions.first!,
                                    queryID: TestEvent.queryID,
                                    userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConversionInSearch() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 2

    testEventTracker.didConvertObjectsAfterSearch = { _, indexName, userToken, _, objectIDs, queryID in
      exp.fulfill()
      XCTAssertEqual(TestEvent.queryID, queryID)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      if objectIDs.count > 1 {
        XCTAssertEqual(TestEvent.objectIDs, objectIDs)
      } else {
        XCTAssertEqual(TestEvent.objectIDs.first, objectIDs.first)
      }
    }

    testInsights.convertedAfterSearch(eventName: TestEvent.eventName,
                                      indexName: TestEvent.indexName,
                                      objectIDs: TestEvent.objectIDs,
                                      queryID: TestEvent.queryID,
                                      userToken: TestEvent.userToken)

    testInsights.convertedAfterSearch(eventName: TestEvent.eventName,
                                      indexName: TestEvent.indexName,
                                      objectID: TestEvent.objectIDs.first!,
                                      queryID: TestEvent.queryID,
                                      userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testClickWithObjects() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 2

    testEventTracker.didClickObjects = { eventName, indexName, userToken, _, objectIDs in

      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      if objectIDs.count > 1 {
        XCTAssertEqual(TestEvent.objectIDs, objectIDs)
      } else {
        XCTAssertEqual(TestEvent.objectIDs.first, objectIDs.first)
      }
    }

    testInsights.clicked(eventName: TestEvent.eventName,
                         indexName: TestEvent.indexName,
                         objectIDs: TestEvent.objectIDs,
                         userToken: TestEvent.userToken)

    testInsights.clicked(eventName: TestEvent.eventName,
                         indexName: TestEvent.indexName,
                         objectID: TestEvent.objectIDs.first!,
                         userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testClickWithFilters() {
    let exp = expectation(description: "callback expectation")

    testEventTracker.didClickFilters = { eventName, indexName, userToken, _, filters in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      XCTAssertEqual(TestEvent.filters, filters)
    }

    testInsights.clicked(eventName: TestEvent.eventName,
                         indexName: TestEvent.indexName,
                         filters: TestEvent.filters,
                         userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConversionWithObjects() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 2

    testEventTracker.didConvertObjects = { eventName, indexName, userToken, _, objectIDs in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      if objectIDs.count > 1 {
        XCTAssertEqual(TestEvent.objectIDs, objectIDs)
      } else {
        XCTAssertEqual(TestEvent.objectIDs.first, objectIDs.first)
      }
    }

    testInsights.converted(eventName: TestEvent.eventName,
                           indexName: TestEvent.indexName,
                           objectIDs: TestEvent.objectIDs,
                           userToken: TestEvent.userToken)

    testInsights.converted(eventName: TestEvent.eventName,
                           indexName: TestEvent.indexName,
                           objectID: TestEvent.objectIDs.first!,
                           userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConversionWithFilters() {
    let exp = expectation(description: "callback expectation")

    testEventTracker.didConvertFilters = { eventName, indexName, userToken, _, filters in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      XCTAssertEqual(TestEvent.filters, filters)
    }

    testInsights.converted(eventName: TestEvent.eventName,
                           indexName: TestEvent.indexName,
                           filters: TestEvent.filters,
                           userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testViewWithObjects() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 2

    testEventTracker.didViewObjects = { eventName, indexName, userToken, _, objectIDs in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      if objectIDs.count > 1 {
        XCTAssertEqual(TestEvent.objectIDs, objectIDs)
      } else {
        XCTAssertEqual(TestEvent.objectIDs.first, objectIDs.first)
      }
    }

    testInsights.viewed(eventName: TestEvent.eventName,
                        indexName: TestEvent.indexName,
                        objectIDs: TestEvent.objectIDs,
                        userToken: TestEvent.userToken)

    testInsights.viewed(eventName: TestEvent.eventName,
                        indexName: TestEvent.indexName,
                        objectID: TestEvent.objectIDs.first!,
                        userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testViewWithFilters() {
    let exp = expectation(description: "callback expectation")

    testEventTracker.didViewFilters = { eventName, indexName, userToken, _, filters in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      XCTAssertEqual(TestEvent.filters, filters)
    }
    testEventTracker.didViewFilters = { eventName, indexName, userToken, _, filters in
      exp.fulfill()
      XCTAssertEqual(TestEvent.eventName, eventName)
      XCTAssertEqual(TestEvent.userToken, userToken)
      XCTAssertEqual(TestEvent.indexName, indexName)
      XCTAssertEqual(TestEvent.filters, filters)
    }

    testInsights.viewed(eventName: TestEvent.eventName,
                        indexName: TestEvent.indexName,
                        filters: TestEvent.filters,
                        userToken: TestEvent.userToken)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testEventIsSentCorrectly() {
    let exp = XCTestExpectation(description: "mock web service response")

    let mockService = MockEventService<InsightsEvent> { _ in exp.fulfill() }
    let storage = TestPackageStorage<InsightsEvent>()
    let logger = Logger(label: #function)
    let eventProcessor = EventProcessor(service: mockService,
                                        storage: storage,
                                        packageCapacity: Algolia.Insights.minBatchSize,
                                        flushNotificationName: nil,
                                        flushDelay: 1,
                                        logger: logger)

    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: logger,
                                    userToken: .none,
                                    generateTimestamps: true)

    let insights = Insights(eventProcessor: eventProcessor,
                            eventTracker: eventTracker,
                            logger: logger)

    insights.clickedAfterSearch(eventName: TestEvent.eventName,
                                indexName: TestEvent.indexName,
                                objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                queryID: TestEvent.queryID)

    wait(for: [exp], timeout: 5)
  }

  func testGlobalAppUserTokenPropagation() {
    let exp = expectation(description: "process event expectation")

    let eventProcessor = TestEventProcessor()

    eventProcessor.didProcess = { event in
      XCTAssertEqual(Insights.userToken, event.userToken)
      exp.fulfill()
    }

    let logger = Logger(label: #function)

    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: logger,
                                    userToken: .none,
                                    generateTimestamps: true)

    let insights = Insights(eventProcessor: eventProcessor,
                            eventTracker: eventTracker,
                            logger: logger)

    insights.clickedAfterSearch(eventName: TestEvent.eventName,
                                indexName: TestEvent.indexName,
                                objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                queryID: TestEvent.queryID)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testPerAppUserTokenPropagation() {
    let exp = expectation(description: "process event expectation")

    let eventProcessor = TestEventProcessor()

    eventProcessor.didProcess = { event in
      XCTAssertEqual("global_token", event.userToken)
      exp.fulfill()
    }

    let logger = Logger(label: #function)

    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: logger,
                                    userToken: "global_token",
                                    generateTimestamps: true)

    let insights = Insights(eventProcessor: eventProcessor,
                            eventTracker: eventTracker,
                            logger: logger)

    insights.clickedAfterSearch(eventName: TestEvent.eventName,
                                indexName: TestEvent.indexName,
                                objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                queryID: TestEvent.queryID)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testUserTokenChange() {
    let userToken: UserToken = "testUserToken1"

    let eventProcessor = TestEventProcessor()
    let logger = Logger(label: #function)
    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: logger,
                                    userToken: userToken,
                                    generateTimestamps: true)

    let insights = Insights(eventProcessor: eventProcessor,
                            eventTracker: eventTracker,
                            logger: logger)

    XCTAssertEqual(insights.userToken, userToken)

    let modifiedUserToken: UserToken = "testUserToken2"

    insights.userToken = modifiedUserToken

    XCTAssertEqual(insights.userToken, modifiedUserToken)
  }

  func testRegister() {
    let userToken: UserToken = "testUserToken1"

    Insights.register(appId: "myAppID", apiKey: "apiKey", userToken: userToken)

    XCTAssertEqual(Insights.shared(appId: "myAppID")?.userToken, userToken)

    let modifiedUserToken: UserToken = "testUserToken2"

    Insights.shared(appId: "myAppID")?.userToken = modifiedUserToken

    XCTAssertEqual(Insights.shared(appId: "myAppID")?.userToken, modifiedUserToken)
  }

  func testExpiredEventsPurge() {
    let exp = expectation(description: "process event expectation")

    let eventProcessor = TestEventProcessor()
    let logger = Logger(label: #function)

    let eventTracker = EventTracker(eventProcessor: eventProcessor,
                                    logger: logger,
                                    userToken: "global_token",
                                    generateTimestamps: true)

    eventProcessor.didProcess = { event in
      XCTAssertEqual("global_token", event.userToken)
      exp.fulfill()
    }

    let insights = Insights(eventProcessor: eventProcessor,
                            eventTracker: eventTracker,
                            logger: logger)

    insights.clickedAfterSearch(eventName: TestEvent.eventName,
                                indexName: TestEvent.indexName,
                                objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                queryID: TestEvent.queryID)

    waitForExpectations(timeout: 5, handler: nil)
  }
}
