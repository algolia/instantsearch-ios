//
//  PackageTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
import AlgoliaSearchClient
@testable import InstantSearchInsights

class PackageTests: XCTestCase {
    
  func testEventsPackageCoding() throws {
    let package = try Package<InsightsEvent>(events: [
      .click(name: "ClickEventName", indexName: "Index1", userToken: "User1", filters: ["f1"]),
      .view(name: "ViewEventName", indexName: "Index2", userToken: "User2", filters: ["f2"])
    ])
    try AssertEncodeDecode(package, [
      "id": .init(package.id),
      "capacity": .init(Algolia.Insights.maxEventCountInPackage),
      "items": [
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
    
    let package = Package<InsightsEvent>()
    
    XCTAssertTrue(package.items.isEmpty)
    
  }
  
  func testConstrutionWithEvent() throws {
    
    let package = Package(event: try .click(name: "event name", indexName: "index name", userToken: "user_token", filters: ["name:value"]))
    
    XCTAssertEqual(package.items.count, 1)
    
  }
  
  func testConstructionWithMultipleEvents() {
    
    let eventsCount = 10
    let events = [InsightsEvent](repeating: TestEvent.click, count: eventsCount)
    let package = try! Package(events: events)
    
    XCTAssertEqual(package.items.count, eventsCount)
    
  }
  
  func testPackageOverflow() {
    
    let exp = expectation(description: "error callback expectation")
    let eventsCount = Algolia.Insights.maxEventCountInPackage + 1
    let events = [InsightsEvent](repeating: TestEvent.click, count: eventsCount)
    
    XCTAssertThrowsError(try Package(events: events), "constructor must throw an error due to events count overflow") { error in
      exp.fulfill()
      XCTAssertEqual(error as? Package<InsightsEvent>.Error, Package.Error.packageOverflow(capacity: Algolia.Insights.maxEventCountInPackage))
      XCTAssertEqual(error.localizedDescription, "Max items count in package is \(Algolia.Insights.maxEventCountInPackage)")
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
  func testIsFull() throws {
    
    let eventsCount = Algolia.Insights.maxEventCountInPackage
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)
    let eventsPackage = try Package(events: events)
    
    XCTAssertTrue(eventsPackage.isFull)
    XCTAssertFalse(Package().isFull)
    
  }
  
  func testAppend() {
    
    let eventsCount = 100
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)
    let eventsPackage = try! Package(events: events)
    let updatedPackage = try! eventsPackage.appending(TestEvent.random)
    
    XCTAssertEqual(updatedPackage.items.count, eventsCount + 1)
    
    let anotherUpdatedPackage = try! eventsPackage.appending(events)
    
    XCTAssertEqual(anotherUpdatedPackage.items.count, events.count * 2)
  }
  
}
