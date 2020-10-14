//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class TestEventTracker: EventTrackable {
    
    var didViewObjects: ((String, String, String?, [String]) -> Void)?
    var didViewFilters: ((String, String, String?, [String]) -> Void)?
    var didClickObjects: ((String, String, String?, [String]) -> Void)?
    var didClickObjectsAfterSearch: ((String, String, String?, [String], [Int], String) -> Void)?
    var didClickFilters: ((String, String, String?, [String]) -> Void)?
    var didConvertObjects: ((String, String, String?, [String]) -> Void)?
    var didConvertObjectsAfterSearch: ((String, String, String?, [String], String) -> Void)?
    var didConvertFilters: ((String, String, String?, [String]) -> Void)?
    
    func view(eventName: String, indexName: String, userToken: String?, objectIDs: [String]) {
        didViewObjects?(eventName, indexName, userToken, objectIDs)
    }
    
    func view(eventName: String, indexName: String, userToken: String?, filters: [String]) {
        didViewFilters?(eventName, indexName, userToken, filters)
    }
    
    func click(eventName: String, indexName: String, userToken: String?, objectIDs: [String]) {
        didClickObjects?(eventName, indexName, userToken, objectIDs)
    }
    
    func click(eventName: String, indexName: String, userToken: String?, objectIDs: [String], positions: [Int], queryID: String) {
        didClickObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, positions, queryID)
    }
    
    func click(eventName: String, indexName: String, userToken: String?, filters: [String]) {
        didClickFilters?(eventName, indexName, userToken, filters)
    }
    
    func conversion(eventName: String, indexName: String, userToken: String?, objectIDs: [String]) {
        didConvertObjects?(eventName, indexName, userToken, objectIDs)
    }
    
    func conversion(eventName: String, indexName: String, userToken: String?, objectIDs: [String], queryID: String) {
        didConvertObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, queryID)
    }
    
    func conversion(eventName: String, indexName: String, userToken: String?, filters: [String]) {
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
    
    struct Expected {
        let indexName = "index name"
        let eventName = "event name"
        let userToken = "user token"
        let timestamp = Date().timeIntervalSince1970
        let queryID = "query id"
        let objectIDs = ["o1", "o2"]
        let positions = [1, 2]
        var objectIDsWithPositions: [(String, Int)] {
            return zip(objectIDs, positions).map { ($0, $1) }
        }
        let filters = ["brand:apple", "color:red"]
    
    }
    
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
        let expected = Expected()
        
        testEventTracker.didClickObjectsAfterSearch = { eventName, indexName, userToken, objectIDs, positions, queryID in
            exp.fulfill()
            XCTAssertEqual(expected.queryID, queryID)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(objectIDs.count, positions.count)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
                XCTAssertEqual(expected.positions, positions)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
                XCTAssertEqual(expected.positions.first, positions.first)
            }
        }
        
        testInsights.clickedAfterSearch(eventName: expected.eventName,
                                      indexName: expected.indexName,
                                      objectIDsWithPositions: expected.objectIDsWithPositions,
                                      queryID: expected.queryID,
                                      userToken: expected.userToken)
        
        testInsights.clickedAfterSearch(eventName: expected.eventName,
                                      indexName: expected.indexName,
                                      objectIDs: expected.objectIDs,
                                      positions: expected.positions,
                                      queryID: expected.queryID,
                                      userToken: expected.userToken)
        
        testInsights.clickedAfterSearch(eventName: expected.eventName,
                                      indexName: expected.indexName,
                                      objectID: expected.objectIDs.first!,
                                      position: expected.positions.first!,
                                      queryID: expected.queryID,
                                      userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testConversionInSearch() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        testEventTracker.didConvertObjectsAfterSearch = { eventName, indexName, userToken, objectIDs, queryID in
            exp.fulfill()
            XCTAssertEqual(expected.queryID, queryID)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }

        }
        
        testInsights.convertedAfterSearch(eventName: expected.eventName,
                                           indexName: expected.indexName,
                                           objectIDs: expected.objectIDs,
                                           queryID: expected.queryID,
                                           userToken: expected.userToken)
        
        testInsights.convertedAfterSearch(eventName: expected.eventName,
                                           indexName: expected.indexName,
                                           objectID: expected.objectIDs.first!,
                                           queryID: expected.queryID,
                                           userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testClickWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        testEventTracker.didClickObjects = { eventName, indexName, userToken, objectIDs in
            
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
            
        }
        
        testInsights.clicked(eventName: expected.eventName,
                           indexName: expected.indexName,
                           objectIDs: expected.objectIDs,
                           userToken: expected.userToken)
        
        testInsights.clicked(eventName: expected.eventName,
                           indexName: expected.indexName,
                           objectID: expected.objectIDs.first!,
                           userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testClickWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        testEventTracker.didClickFilters = { eventName, indexName, userToken, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.filters, filters)
        }
        
        testInsights.clicked(eventName: expected.eventName,
                           indexName: expected.indexName,
                           filters: expected.filters,
                           userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testConversionWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        testEventTracker.didConvertObjects = { eventName, indexName, userToken, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.converted(eventName: expected.eventName,
                                indexName: expected.indexName,
                                objectIDs: expected.objectIDs,
                                userToken: expected.userToken)
        
        testInsights.converted(eventName: expected.eventName,
                                indexName: expected.indexName,
                                objectID: expected.objectIDs.first!,
                                userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testConversionWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        testEventTracker.didConvertFilters = { eventName, indexName, userToken, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.filters, filters)
        }

        
        testInsights.converted(eventName: expected.eventName,
                                indexName: expected.indexName,
                                filters: expected.filters,
                                userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testViewWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        testEventTracker.didViewObjects = { eventName, indexName, userToken, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.viewed(eventName: expected.eventName,
                          indexName: expected.indexName,
                          objectIDs: expected.objectIDs,
                          userToken: expected.userToken)
        
        testInsights.viewed(eventName: expected.eventName,
                          indexName: expected.indexName,
                          objectID: expected.objectIDs.first!,
                          userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testViewWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        testEventTracker.didViewFilters = { eventName, indexName, userToken, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.filters, filters)
        }
        
        testInsights.viewed(eventName: expected.eventName,
                          indexName: expected.indexName,
                          filters: expected.filters,
                          userToken: expected.userToken)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testEventIsSentCorrectly() {

        let exp = XCTestExpectation(description: "mock web service response")
        let expected = Expected()
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: testCredentials.appId) { resource in
            if let res = resource as? Resource<Bool, WebserviceError> {
                XCTAssertEqual(res.method.method, "POST")
                _ = res.method.map(f: { data in
                    XCTAssertNotNil(data)
                    let jsonDecoder = JSONDecoder()
                    do {
                      let package = try jsonDecoder.decode([String: Array<EventWrapper>].self, from: data)
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
        
        insights.clickedAfterSearch(eventName: expected.eventName,
                                  indexName: expected.indexName,
                                  objectIDsWithPositions: expected.objectIDsWithPositions,
                                  queryID: expected.queryID)

        wait(for: [exp], timeout: 5)
    }
    
    func testGlobalAppUserTokenPropagation() {
        
        let exp = expectation(description: "process event expectation")
        let expected = Expected()

        let eventProcessor = TestEventProcessor()
        
        eventProcessor.didProcess = { event in
            XCTAssertEqual(Insights.userToken, event.userToken)
            exp.fulfill()
        }
        
        let logger = Logger(testCredentials.appId)
        
        let insights = Insights(eventsProcessor: eventProcessor, logger: logger)
        
        insights.clickedAfterSearch(eventName: expected.eventName,
                                  indexName: expected.indexName,
                                  objectIDsWithPositions: expected.objectIDsWithPositions,
                                  queryID: expected.queryID)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testPerAppUserTokenPropagation() {
        
        let exp = expectation(description: "process event expectation")
        
        let expected = Expected()
        
        let eventProcessor = TestEventProcessor()
        
        eventProcessor.didProcess = { event in
            XCTAssertEqual("global token", event.userToken)
            exp.fulfill()
        }
        
        let logger = Logger(testCredentials.appId)
        
        let insights = Insights(eventsProcessor: eventProcessor, userToken: "global token", logger: logger)
        
        insights.clickedAfterSearch(eventName: expected.eventName,
                                  indexName: expected.indexName,
                                  objectIDsWithPositions: expected.objectIDsWithPositions,
                                  queryID: expected.queryID)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testUserTokenChange() {
        
        let userToken = "testUserToken1"
        
        let eventProcessor = TestEventProcessor()
        let logger = Logger(testCredentials.appId)

        let insights = Insights(eventsProcessor: eventProcessor,
                                userToken: userToken,
                                logger: logger)
        
        XCTAssertEqual(insights.userToken, userToken)
        
        let modifiedUserToken = "testUserToken2"
        
        insights.userToken = modifiedUserToken
        
        XCTAssertEqual(insights.userToken, modifiedUserToken)
        
        
    }
    
    func testRegister() {
        
        let userToken = "testUserToken1"
        
        Insights.register(appId: "myAppID", apiKey: "apiKey", userToken: userToken)
        
        XCTAssertEqual(Insights.shared(appId: "myAppID")?.userToken, userToken)
        
        let modifiedUserToken = "testUserToken2"
        
        Insights.shared(appId: "myAppID")?.userToken = modifiedUserToken
        
        XCTAssertEqual(Insights.shared(appId: "myAppID")?.userToken, modifiedUserToken)
        
        
    }
    
}
