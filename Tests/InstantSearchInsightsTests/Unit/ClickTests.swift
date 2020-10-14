//
//  ClickTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ClickTests: XCTestCase {
    
    func testClickEncoding() {
        
        let expectedEventType = EventType.click
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedObjectIDsWithPositions = [("o1", 1), ("o2", 2)]
        let expectedFilter = "brand:apple"

        let event = try! ClickEvent(name: expectedEventName,
                               indexName: expectedIndexName,
                               userToken: expectedUserToken,
                               timestamp: expectedTimeStamp,
                               queryID: expectedQueryID,
                               objectIDsWithPositions: expectedObjectIDsWithPositions)
        
        let eventDictionary = Dictionary<String, Any>(event)!
        
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, expectedEventType.rawValue)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, expectedEventName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.indexName.rawValue] as? String, expectedIndexName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, expectedUserToken)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.timestamp.rawValue] as? Int, Int(expectedTimeStamp))
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String, expectedQueryID)
        XCTAssertEqual(eventDictionary[ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue] as? [String], expectedObjectIDsWithPositions.map { $0.0 })
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.positions.rawValue] as? [Int], expectedObjectIDsWithPositions.map { $0.1 })
        
        let eventWithFilters = try! ClickEvent(name: expectedEventName,
                                          indexName: expectedIndexName,
                                          userToken: expectedUserToken,
                                          timestamp: expectedTimeStamp,
                                          objectIDsOrFilters: .filters([expectedFilter]),
                                          positions: .none)
        
        let eventWithFiltersDictionary = Dictionary<String, Any>(eventWithFilters)!
        
        XCTAssertEqual(eventWithFiltersDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, expectedEventType.rawValue)
        XCTAssertEqual(eventWithFiltersDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, expectedEventName)
        XCTAssertEqual(eventWithFiltersDictionary[CoreEvent.CodingKeys.indexName.rawValue] as? String, expectedIndexName)
        XCTAssertEqual(eventWithFiltersDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, expectedUserToken)
        XCTAssertEqual(eventWithFiltersDictionary[CoreEvent.CodingKeys.timestamp.rawValue] as? Int, Int(expectedTimeStamp))
        XCTAssertEqual(eventWithFiltersDictionary[ObjectsIDsOrFilters.CodingKeys.filters.rawValue] as? [String], [expectedFilter])
        XCTAssertNil(eventWithFiltersDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String)
        XCTAssertNil(eventWithFiltersDictionary[CoreEvent.CodingKeys.positions.rawValue] as? [Int])
    }
    
    func testClickDecoding() {
        
        let expectedEventType = EventType.click
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter =  "brand:apple"
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
            let event = try jsonDecoder.decode(ClickEvent.self, from: data)
            
            XCTAssertEqual(event.type, expectedEventType)
            XCTAssertEqual(event.name, expectedEventName)
            XCTAssertEqual(event.indexName, expectedIndexName)
            XCTAssertEqual(event.userToken, expectedUserToken)
            XCTAssertEqual(event.queryID, expectedQueryID)
            XCTAssertEqual(event.timestamp, expectedTimeStamp)
            XCTAssertEqual(event.objectIDsOrFilters, expectedWrappedFilter)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
        
    }

    
}
