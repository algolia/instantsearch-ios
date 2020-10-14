//
//  ViewTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ViewTests: XCTestCase {
    
    func testViewEncoding() {
        
        let expectedEventType = EventType.view
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter =  "brand:apple"
        
        let event = try! ViewEvent(name: expectedEventName,
                              indexName: expectedIndexName,
                              userToken: expectedUserToken,
                              timestamp: expectedTimeStamp,
                              queryID: expectedQueryID,
                              objectIDsOrFilters: .filters([expectedFilter]))
        
        let eventDictionary = Dictionary(event)!
        
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, expectedEventType.rawValue)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, expectedEventName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.indexName.rawValue] as? String, expectedIndexName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, expectedUserToken)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.timestamp.rawValue] as? Int, Int(expectedTimeStamp))
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String, expectedQueryID)
        XCTAssertEqual(eventDictionary[ObjectsIDsOrFilters.CodingKeys.filters.rawValue] as? [String], [expectedFilter])
        
    }
    
    func testViewDecoding() {
        
        let expectedEventType = EventType.view
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter =  "brand:apple"
        
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
            let event = try jsonDecoder.decode(ViewEvent.self, from: data)
            
            XCTAssertEqual(event.type, expectedEventType)
            XCTAssertEqual(event.name, expectedEventName)
            XCTAssertEqual(event.indexName, expectedIndexName)
            XCTAssertEqual(event.userToken, expectedUserToken)
            XCTAssertEqual(event.queryID, expectedQueryID)
            XCTAssertEqual(event.timestamp, expectedTimeStamp)
            XCTAssertEqual(event.objectIDsOrFilters, .filters([expectedFilter]))
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
}
