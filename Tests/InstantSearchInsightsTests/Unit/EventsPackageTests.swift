//
//  EventsPackageTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
import AlgoliaSearchClient
@testable import InstantSearchInsights

struct TestEvent {
  
  static let eventName: EventName = "test event name"
  static let indexName: IndexName = "test index"
  static let userToken: UserToken = "testtoken"
  static let queryID: QueryID = "test query id"
  static let timeStamp = Date()
  static let objectIDs: [ObjectID] = ["o1", "o2", "o3"]
  static let positions: [Int] = [1, 2, 3]
  static let filters = ["key1:value1", "key2:value2"]
  static var objectIDsWithPositions: [(ObjectID, Int)] { zip(objectIDs, positions).map { $0 } }
  
  static var click: InsightsEvent {
    [clickWithFilters, clickWithObjects].randomElement()!
  }
  
  static var clickWithFilters: InsightsEvent {
    try! .click(name: "click event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, filters: filters)
  }
  
  static var clickWithObjects: InsightsEvent {
    try! .click(name: "click event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, objectIDs: objectIDs)
  }
  
  static var viewWithObjects: InsightsEvent {
    try! .view(name: "view event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, objectIDs: objectIDs)
  }

  static var viewWithFilters: InsightsEvent {
    try! .view(name: "view event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, filters: filters)
  }

  static var view: InsightsEvent {
    [viewWithObjects, viewWithFilters].randomElement()!
  }
  
  static var conversionWithObjects: InsightsEvent {
    try! .conversion(name: "conversion event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, queryID: queryID, objectIDs: objectIDs)
  }
  
  static var conversionWithFilters: InsightsEvent {
    try! .conversion(name: "conversion event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, queryID: queryID, filters: filters)
  }

  
  static var conversion: InsightsEvent {
    [conversionWithObjects, conversionWithFilters].randomElement()!
  }
  
  static var random: InsightsEvent {
    [click, view, conversion].randomElement()!
  }
  
}

class EventsPackageTests: XCTestCase {
  
  func testEventsPackageCoding() throws {
    let package = try EventsPackage(events: [
      .click(name: "ClickEventName", indexName: "Index1", userToken: "User1", filters: ["f1"]),
      .view(name: "ViewEventName", indexName: "Index2", userToken: "User2", filters: ["f2"])
    ])
    try AssertEncodeDecode(package, [
      "id": .init(package.id),
      "events": [
        [
          "eventType": "click",
          "eventName": "ClickEventName",
          "index": "Index1",
          "userToken": "User1",
          "filters": ["f1"]
        ],
        [
          "eventType": "view",
          "eventName": "ViewEventName",
          "index": "Index2",
          "userToken": "User2",
          "filters": ["f2"]
        ]
      ]
    ])
  }
  
  func testDefaultConstructor() {
    
    let package = EventsPackage()
    
    XCTAssertTrue(package.events.isEmpty)
    
  }
  
  func testConstrutionWithEvent() throws {
    
    let package = EventsPackage(event: try .click(name: "event name", indexName: "index name", userToken: "user_token", filters: ["name:value"]))
    
    XCTAssertEqual(package.events.count, 1)
    
  }
  
  func testConstructionWithMultipleEvents() {
    
    let eventsCount = 10
    let events = [InsightsEvent](repeating: TestEvent.click, count: eventsCount)
    let package = try! EventsPackage(events: events)
    
    XCTAssertEqual(package.events.count, eventsCount)
    
  }
  
  func testPackageOverflow() {
    
    let exp = expectation(description: "error callback expectation")
    let eventsCount = EventsPackage.maxEventCountInPackage + 1
    let events = [InsightsEvent](repeating: TestEvent.click, count: eventsCount)
    
    XCTAssertThrowsError(try EventsPackage(events: events), "constructor must throw an error due to events count overflow") { error in
      exp.fulfill()
      XCTAssertEqual(error as? EventsPackage.Error, EventsPackage.Error.packageOverflow)
      XCTAssertEqual(error.localizedDescription, "Max events count in package is \(EventsPackage.maxEventCountInPackage)")
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testIsFull() throws {
    
    let eventsCount = EventsPackage.maxEventCountInPackage
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)
    let eventsPackage = try EventsPackage(events: events)
    
    XCTAssertTrue(eventsPackage.isFull)
    XCTAssertFalse(EventsPackage().isFull)
    
  }
  
  func testAppend() {
    
    let eventsCount = 100
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)
    let eventsPackage = try! EventsPackage(events: events)
    let updatedPackage = try!eventsPackage.appending(TestEvent.random)
    
    XCTAssertEqual(updatedPackage.events.count, eventsCount + 1)
    
    let anotherUpdatedPackage = try! eventsPackage.appending(events)
    
    XCTAssertEqual(anotherUpdatedPackage.events.count, events.count * 2)
  }
  
  func testSync() {
    
    let eventsPackage = EventsPackage(event: TestEvent.random)
    
    let resource = eventsPackage.sync()
    
    switch resource.method {
    case .post([], let body):
      let jsonDecoder = JSONDecoder()
      let package = try! jsonDecoder.decode([String: Array<InsightsEvent>].self, from: body)
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
