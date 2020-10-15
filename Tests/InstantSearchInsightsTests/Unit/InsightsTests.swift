//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
import AlgoliaSearchClient
@testable import InstantSearchInsights

class TestEventTracker: EventTrackable {
  
  var didViewObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didViewFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  var didClickObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didClickObjectsAfterSearch: ((EventName, IndexName, UserToken?, [ObjectID], [Int], QueryID) -> Void)?
  var didClickFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  var didConvertObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didConvertObjectsAfterSearch: ((EventName, IndexName, UserToken?, [ObjectID], QueryID) -> Void)?
  var didConvertFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  
  func view(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didViewObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func view(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didViewFilters?(eventName, indexName, userToken, filters)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didClickObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID], positions: [Int], queryID: QueryID) {
    didClickObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, positions, queryID)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didClickFilters?(eventName, indexName, userToken, filters)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didConvertObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID], queryID: QueryID) {
    didConvertObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, queryID)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didConvertFilters?(eventName, indexName, userToken, filters)
  }
  
}

class InsightsTests: XCTestCase {
  
  let testCredentials = Credentials(appId: "test app id", apiKey: "test key")
  let testEventTracker = TestEventTracker()
  let testEventProcessor = TestEventProcessor()
  let testLogger = Logger("test app id")
  lazy var testInsights: Insights = {
    return Insights(eventProcessor: testEventProcessor, eventTracker: testEventTracker, logger: testLogger)
  }()
  
  override func setUp() {
    // Remove locally stored events packages for test index
    guard let filePath = LocalStorage<[EventsPackage]>.filePath(for: testCredentials.appId) else { return }
    LocalStorage<[EventsPackage]>.serialize([], file: filePath)
  }
  
  func testInitShouldFail() {
    let insightsRegister = Insights.shared(appId: "test")
    XCTAssertNil(insightsRegister)
    
    Insights.register(appId: "app1", apiKey: "key1")
    Insights.register(appId: "app2", apiKey: "key2")
    
    XCTAssertNil(Insights.shared)
  }
  
  func testInitShouldWork() {
    
    let insightsRegister = Insights.register(appId: testCredentials.appId, apiKey: testCredentials.apiKey)
    XCTAssertNotNil(insightsRegister)
    
    let insightsShared = Insights.shared(appId: testCredentials.appId)
    XCTAssertNotNil(insightsShared)
    
    XCTAssertEqual(insightsRegister, insightsShared, "Getting the Insights instance from register and shared should be the same")
    
  }
  
  func testOptIntOptOut() {
    
    let insightsRegister = Insights.register(appId: testCredentials.appId, apiKey: testCredentials.apiKey)
    
    XCTAssertTrue(insightsRegister.eventProcessor.isActive)
    insightsRegister.isActive = false
    XCTAssertFalse(insightsRegister.eventProcessor.isActive)
    
  }
  
  func testClickInSearch() {
    let exp = expectation(description: "callback expectation")
    exp.expectedFulfillmentCount = 3
    
    testEventTracker.didClickObjectsAfterSearch = { eventName, indexName, userToken, objectIDs, positions, queryID in
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
    
    testEventTracker.didConvertObjectsAfterSearch = { eventName, indexName, userToken, objectIDs, queryID in
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
    
    testEventTracker.didClickObjects = { eventName, indexName, userToken, objectIDs in
      
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
    
    testEventTracker.didClickFilters = { eventName, indexName, userToken, filters in
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
    
    testEventTracker.didConvertObjects = { eventName, indexName, userToken, objectIDs in
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
    
    testEventTracker.didConvertFilters = { eventName, indexName, userToken, filters in
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
    
    testEventTracker.didViewObjects = { eventName, indexName, userToken, objectIDs in
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
    
    testEventTracker.didViewFilters = { eventName, indexName, userToken, filters in
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
    
    let mockWS = MockWebServiceHelper.getMockWebService(appId: testCredentials.appId) { resource in
      if let res = resource as? Resource<Bool, WebserviceError> {
        XCTAssertEqual(res.method.method, "POST")
        _ = res.method.map(f: { data in
          XCTAssertNotNil(data)
          let jsonDecoder = JSONDecoder()
          do {
            let package = try jsonDecoder.decode([String: Array<InsightsEvent>].self, from: data)
            XCTAssertNotNil(package[EventsPackage.CodingKeys.events.rawValue])
            exp.fulfill()
          } catch _ {
            XCTFail("Unable to construct EventsPackage with provided JSON")
          }
        })
      } else {
        XCTFail("Unable to cast resource")
      }
    }
    
    let insights = Insights(credentials: Credentials(appId: testCredentials.appId,
                                                     apiKey: testCredentials.apiKey),
                            webService: mockWS,
                            flushDelay: 1,
                            logger: Logger(testCredentials.appId))
    
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
    
    let logger = Logger(testCredentials.appId)
    
    let insights = Insights(eventsProcessor: eventProcessor, logger: logger)
    
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
    
    let logger = Logger(testCredentials.appId)
    
    let insights = Insights(eventsProcessor: eventProcessor, userToken: "global_token", logger: logger)
    
    insights.clickedAfterSearch(eventName: TestEvent.eventName,
                                indexName: TestEvent.indexName,
                                objectIDsWithPositions: TestEvent.objectIDsWithPositions,
                                queryID: TestEvent.queryID)
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testUserTokenChange() {
    
    let userToken: UserToken = "testUserToken1"
    
    let eventProcessor = TestEventProcessor()
    let logger = Logger(testCredentials.appId)
    
    let insights = Insights(eventsProcessor: eventProcessor,
                            userToken: userToken,
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
  
}
