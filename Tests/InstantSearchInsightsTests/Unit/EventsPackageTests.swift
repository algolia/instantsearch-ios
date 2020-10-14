//
//  EventsPackageTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsPackageTests: XCTestCase {
    
    func testEventsPackageEncoding() {
        
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter =  "brand:apple"
        
        let event1 = try! ConversionEvent(name: "test conversion event", indexName: expectedIndexName, userToken: expectedUserToken, timestamp: expectedTimeStamp, queryID: expectedQueryID, objectIDsOrFilters: .filters([expectedFilter]))
        let event2 = try! ViewEvent(name: "test view event", indexName: expectedIndexName, userToken: expectedUserToken, timestamp: expectedTimeStamp, queryID: expectedQueryID, objectIDsOrFilters: .filters([expectedFilter]))
        
        do {
            let package = try EventsPackage(events: [.conversion(event1), .view(event2)])
            let dictionary = Dictionary(package)!
            
            guard let events = dictionary["events"] as? [[String: Any]], events.count == 2 else {
                XCTFail("Incorrect events count in package")
                return
            }
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
    func testEventsPackageDecoding() {
        
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().millisecondsSince1970
        let expectedFilter = "brand:apple"
        
        let eventDictionary1: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: EventType.conversion.rawValue,
            CoreEvent.CodingKeys.name.rawValue: "test conversion event",
            CoreEvent.CodingKeys.indexName.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter],
            ]
        
        let eventDictionary2: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: EventType.view.rawValue,
            CoreEvent.CodingKeys.name.rawValue: "test view event",
            CoreEvent.CodingKeys.indexName.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter],
            ]
        
        let packageDictionary: [String: Any] = [
            "id": "test package id",
            "events": [eventDictionary1, eventDictionary2],
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: packageDictionary, options: [])
        
        do {
            let decoder = JSONDecoder()
            let package = try decoder.decode(EventsPackage.self, from: data)
            XCTAssertEqual(package.id, "test package id")
            XCTAssertEqual(package.events.count, 2)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
    func testDefaultConstructor() {
        
        let package = EventsPackage()
        
        XCTAssertTrue(package.events.isEmpty)
        
    }
    
    func testConstrutionWithEvent() {
        
        let package = EventsPackage(event: .custom(TestEvent.template))
        
        XCTAssertEqual(package.events.count, 1)
        
    }
    
    func testConstructionWithMultipleEvents() {
        
        let eventsCount = 10
        let events = [EventWrapper](repeating: .custom(TestEvent.template), count: eventsCount)
        let package = try! EventsPackage(events: events)
        
        XCTAssertEqual(package.events.count, eventsCount)
        
    }
    
    func testPackageOverflow() {
        
        let exp = expectation(description: "error callback expectation")
        let eventsCount = EventsPackage.maxEventCountInPackage + 1
        let events = [EventWrapper](repeating: .custom(TestEvent.template), count: eventsCount)
        
        XCTAssertThrowsError(try EventsPackage(events: events), "constructor must throw an error due to events count overflow") { error in
            exp.fulfill()
            XCTAssertEqual(error as? EventsPackage.Error, EventsPackage.Error.packageOverflow)
            XCTAssertEqual(error.localizedDescription, "Max events count in package is \(EventsPackage.maxEventCountInPackage)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testIsFull() {
        
        let eventsCount = EventsPackage.maxEventCountInPackage
        let events = [EventWrapper](repeating: .custom(TestEvent.template), count: eventsCount)
        let eventsPackage = try! EventsPackage(events: events)
        
        XCTAssertTrue(eventsPackage.isFull)
        XCTAssertFalse(EventsPackage().isFull)
        
    }
    
    func testAppend() {
        
        let eventsCount = 100
        let events = [EventWrapper](repeating: .custom(TestEvent.template), count: eventsCount)
        let eventsPackage = try! EventsPackage(events: events)
        let updatedPackage = try!eventsPackage.appending(.custom(TestEvent.template))
        
        XCTAssertEqual(updatedPackage.events.count, eventsCount + 1)

        let anotherUpdatedPackage = try! eventsPackage.appending(events)
        
        XCTAssertEqual(anotherUpdatedPackage.events.count, events.count * 2)
    }
    
    func testSync() {
        
        let eventsPackage = EventsPackage(event: .custom(TestEvent.template))
        
        let resource = eventsPackage.sync()
        
        switch resource.method {
        case .post([], let body):
            let jsonDecoder = JSONDecoder()
            let package = try! jsonDecoder.decode([String: Array<EventWrapper>].self, from: body)
            XCTAssertNotNil(package[EventsPackage.CodingKeys.events.rawValue])
            let expectedEvents = package[EventsPackage.CodingKeys.events.rawValue]!
            XCTAssertEqual(expectedEvents.description,
                           eventsPackage.events.description)
            
        default:
            XCTFail("Unexpected method")
        }
        
        let errorData = try! JSONSerialization.data(withJSONObject: ["message": "test error"], options: [])
        guard let error = resource.errorParse(100, errorData) else {
            XCTFail("Error construction failed")
            return
        }
        
        XCTAssertEqual(error.code, 100)
        XCTAssertEqual(error.message, "test error")
        
    }
    
}
