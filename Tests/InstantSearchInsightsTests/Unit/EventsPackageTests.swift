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
  
}
