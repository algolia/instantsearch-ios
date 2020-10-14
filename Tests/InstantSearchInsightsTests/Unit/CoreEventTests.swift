//
//  CoreEventTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class CoreEventTests: XCTestCase {

    func testEventEncoding() {
        
        let expectedType = EventType.click
        let expectedName = "test event name"
        let expectedIndexName = "test index name"
        let expectedUserToken = "test user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedQueryID = "test query id"
        let filter = "category:toys"
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([filter])

        
        let event = try! CoreEvent(type: expectedType,
                                   name: expectedName,
                                   indexName: expectedIndexName,
                                   userToken: expectedUserToken,
                                   timestamp: expectedTimestamp,
                                   queryID: expectedQueryID,
                                   objectIDsOrFilters: expectedWrappedFilter)
        
        let eventDictionary = Dictionary(event)!
        
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, expectedType.rawValue)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, expectedName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.indexName.rawValue] as? String, expectedIndexName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, expectedUserToken)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String, expectedQueryID)
        XCTAssertEqual((eventDictionary[CoreEvent.CodingKeys.timestamp.rawValue] as? TimeInterval).flatMap(Int.init), Int(expectedTimestamp))
        XCTAssertEqual(eventDictionary[ObjectsIDsOrFilters.CodingKeys.filters.rawValue] as? [String], [filter])
        
    }
    
    func testEventDecoding() {
        
        let expectedEventType = EventType.click
        let expectedEventName = "Test event name"
        let expectedIndexName = "Test index name"
        let expectedUserToken = "Test user token"
        let expectedQueryID = "Test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter = "brand:apple"
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([expectedFilter])
        
        let eventDictionary: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: expectedEventType.rawValue,
            CoreEvent.CodingKeys.name.rawValue: expectedEventName,
            CoreEvent.CodingKeys.indexName.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter],
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: eventDictionary, options: [])
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let event = try jsonDecoder.decode(CoreEvent.self, from: data)
            
            XCTAssertEqual(event.type, expectedEventType)
            XCTAssertEqual(event.name, expectedEventName)
            XCTAssertEqual(event.indexName, expectedIndexName)
            XCTAssertEqual(event.userToken, expectedUserToken)
            XCTAssertEqual(event.queryID, expectedQueryID)
            XCTAssertEqual(Int(event.timestamp), Int(expectedTimeStamp))
            XCTAssertEqual(event.objectIDsOrFilters, expectedWrappedFilter)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
    func testInitWithAbstractEvent() {
        
        let expectedType = EventType.conversion
        let expectedName = "test event name"
        let expectedIndexName = "test index name"
        let expectedUserToken = "test user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedQueryID = "test query id"
        let expectedObjectIDs = ["o1", "o2"]
        
        let testEvent = TestEvent(
            type: expectedType,
            name: expectedName,
            indexName: expectedIndexName,
            userToken: expectedUserToken,
            timestamp: expectedTimestamp,
            queryID: expectedQueryID,
            objectIDsOrFilters: .objectIDs(expectedObjectIDs))
        
        let coreEvent = CoreEvent(event: testEvent)
        
        XCTAssertEqual(coreEvent.type, expectedType)
        XCTAssertEqual(coreEvent.name, expectedName)
        XCTAssertEqual(coreEvent.indexName, expectedIndexName)
        XCTAssertEqual(coreEvent.userToken, expectedUserToken)
        XCTAssertEqual(coreEvent.timestamp, expectedTimestamp)
        XCTAssertEqual(coreEvent.queryID, expectedQueryID)
        XCTAssertEqual(coreEvent.objectIDsOrFilters, .objectIDs(expectedObjectIDs))
        
    }
    
    func testEmptyEventName() {
        let exp = expectation(description: "error callback expectation")
        XCTAssertThrowsError(try CoreEvent(type: .click, name: "", indexName: "", userToken: "", timestamp: 0, queryID: .none, objectIDsOrFilters: .objectIDs([])), "constructor must throw an error due to empty event name") { error in
            exp.fulfill()
            switch error {
            case EventConstructionError.emptyEventName:
                break
            default:
                XCTFail("Unexpected error thrown")
            }
            
            XCTAssertEqual(error.localizedDescription, "Event name cannot be empty")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testObjectsOverflow() {
        
        let exp = expectation(description: "error callback expectation")
        let objectIDs = [String](repeating: "o", count: CoreEvent.maxObjectIDsCount + 1)
        
        XCTAssertThrowsError(try CoreEvent(type: .click, name: "correct event name", indexName: "", userToken: "", timestamp: 0, queryID: .none, objectIDsOrFilters: .objectIDs(objectIDs))
        , "constructor must throw an error due to objects IDs overflow") { error in
            exp.fulfill()
            
            
            switch error {
            case EventConstructionError.objectIDsCountOverflow:
                break
            default:
                XCTFail("Unexpected error thrown")
            }

            XCTAssertEqual(error.localizedDescription, "Max objects IDs count in event is \(CoreEvent.maxObjectIDsCount)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testFiltersOverflow() {
        
        let exp = expectation(description: "error callback expectation")
        let filters = [String](repeating: "brand:apple", count: CoreEvent.maxFiltersCount + 1)
        
        XCTAssertThrowsError(try CoreEvent(type: .click, name: "correct event name", indexName: "", userToken: "", timestamp: 0, queryID: .none, objectIDsOrFilters: .filters(filters))
        , "constructor must throw an error due to filters count overflow") { error in
            exp.fulfill()
            switch error {
            case EventConstructionError.filtersCountOverflow:
                break
            default:
                XCTFail("Unexpected error thrown")
            }
            
            XCTAssertEqual(error.localizedDescription, "Max filters count in event is \(CoreEvent.maxFiltersCount)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        
    }
    
}

struct TestEvent: Event {
    
    let type: EventType
    let name: String
    let indexName: String
    let userToken: String
    let timestamp: Int64
    let queryID: String?
    let objectIDsOrFilters: ObjectsIDsOrFilters
    
    static let template = TestEvent(type: .conversion,
                                    name: "test name",
                                    indexName: "test index",
                                    userToken: "test user token",
                                    timestamp: Date().millisecondsSince1970,
                                    queryID: "test query id",
                                    objectIDsOrFilters: .objectIDs(["o1", "o2"]))
    
}
