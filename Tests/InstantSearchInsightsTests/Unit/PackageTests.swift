//
//  PackageTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

@testable import InstantSearchInsights
import XCTest

class PackageTests: XCTestCase {
  func testEventsPackageCoding() throws {
    let clickFilter = FilterFacet(attribute: "filter", value: .string("f1"))
    let viewFilter = FilterFacet(attribute: "filter", value: .string("f2"))
    let package = try Package<InsightsEvent>(events: [
      .clickedFilters(eventName: "ClickEventName",
                      indexName: "Index1",
                      userToken: "User1",
                      timestamp: nil,
                      filters: [clickFilter]),
      .viewedFilters(eventName: "ViewEventName",
                     indexName: "Index2",
                     userToken: "User2",
                     timestamp: nil,
                     filters: [viewFilter])
    ])
    try AssertEncodeDecode(package, [
      "id": .init(package.id),
      "capacity": .init(Algolia.Insights.minBatchSize),
      "items": [
        [
          "eventType": "clickedFilters",
          "eventName": "ClickEventName",
          "indexName": "Index1",
          "userToken": "User1",
          "filters": [
            [
              "attribute": "filter",
              "value": "f1",
              "isNegated": false
            ]
          ]
        ],
        [
          "eventType": "viewedFilters",
          "eventName": "ViewEventName",
          "indexName": "Index2",
          "userToken": "User2",
          "filters": [
            [
              "attribute": "filter",
              "value": "f2",
              "isNegated": false
            ]
          ]
        ]
      ]
    ])
  }

  func testDefaultConstructor() {
    let package = Package<InsightsEvent>()

    XCTAssertTrue(package.items.isEmpty)
  }

  func testConstrutionWithEvent() throws {
    let package = Package(event: .clickedFilters(eventName: "event name",
                                                 indexName: "index name",
                                                 userToken: "user_token",
                                                 timestamp: nil,
                                                 filters: [FilterFacet(attribute: "name", value: .string("value"))]))

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
    let eventsCount = Algolia.Insights.minBatchSize + 1
    let events = [InsightsEvent](repeating: TestEvent.click, count: eventsCount)

    XCTAssertThrowsError(try Package(events: events), "constructor must throw an error due to events count overflow") { error in
      exp.fulfill()
      XCTAssertEqual(error as? Package<InsightsEvent>.Error, Package.Error.packageOverflow(capacity: Algolia.Insights.minBatchSize))
      XCTAssertEqual(error.localizedDescription, "Max items count in package is \(Algolia.Insights.minBatchSize)")
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testIsFull() throws {
    let eventsCount = Algolia.Insights.minBatchSize
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)
    let eventsPackage = try Package(events: events)

    XCTAssertTrue(eventsPackage.isFull)
    XCTAssertFalse(Package().isFull)
  }

  func testAppend() throws {
    let eventsCount = 5
    let events = [InsightsEvent](repeating: TestEvent.random, count: eventsCount)

    let eventsPackage = try Package(events: events)
    let updatedPackage = try eventsPackage.appending(TestEvent.random)

    XCTAssertEqual(updatedPackage.items.count, eventsCount + 1)

    let anotherUpdatedPackage = try eventsPackage.appending(events)

    XCTAssertEqual(anotherUpdatedPackage.items.count, events.count * 2)
  }
}
