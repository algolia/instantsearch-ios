//
//  FilterTrackerTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class FilterTrackerTests: XCTestCase {

  struct Constants {
    static let appID: ApplicationID = "test_app_id"
    static let apiKey: APIKey = "test_api_key"
    static let indexName: IndexName = "test index name"
    static let eventName: EventName = "event name"
    static let customEventName: EventName = "custom event name"
    static let queryID: QueryID = "test query id"

    struct Filter {
      static let facet = Facet(value: "test filter value", count: 10)
      static let attribute: Attribute = "test attribute"
      static let value = "test filter value"
      static let serialized = "\"test attribute\":\"test filter value\""
    }
  }

  let searcher = HitsSearcher(appID: Constants.appID, apiKey: Constants.apiKey, indexName: Constants.indexName)

  let testTracker = TestFiltersTracker()

  let testFilter = Filter.Facet(attribute: Constants.Filter.attribute, stringValue: Constants.Filter.value)

  lazy var tracker: FilterTracker = {
    return FilterTracker(eventName: Constants.eventName, searcher: .singleIndex(searcher), tracker: testTracker)
  }()

  func testClick() {
    let clickExpectation = expectation(description: #function)
    clickExpectation.expectedFulfillmentCount = 2
    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .click)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      clickExpectation.fulfill()
    }

    tracker.trackClick(for: testFilter)
    tracker.trackClick(for: Constants.Filter.facet, attribute: Constants.Filter.attribute)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testClickCustomEventName() {
    let clickCustomEventExpectation = expectation(description: #function)
    clickCustomEventExpectation.expectedFulfillmentCount = 2

    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .click)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      clickCustomEventExpectation.fulfill()
    }

    tracker.trackClick(for: testFilter, eventName: Constants.customEventName)
    tracker.trackClick(for: Constants.Filter.facet, attribute: Constants.Filter.attribute, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testView() {
    let viewExpectation = expectation(description: #function)
    viewExpectation.expectedFulfillmentCount = 2

    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .view)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      viewExpectation.fulfill()
    }

    tracker.trackView(for: testFilter)
    tracker.trackView(for: Constants.Filter.facet, attribute: Constants.Filter.attribute)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testViewCustomEventName() {
    let viewCustomEventExpectation = expectation(description: #function)
    viewCustomEventExpectation.expectedFulfillmentCount = 2

    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .view)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      viewCustomEventExpectation.fulfill()
    }

    tracker.trackView(for: testFilter, eventName: Constants.customEventName)
    tracker.trackView(for: Constants.Filter.facet, attribute: Constants.Filter.attribute, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testConvert() {
    let convertExpectation = expectation(description: #function)
    convertExpectation.expectedFulfillmentCount = 2

    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .convert)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      convertExpectation.fulfill()
    }

    tracker.trackConversion(for: testFilter)
    tracker.trackConversion(for: Constants.Filter.facet, attribute: Constants.Filter.attribute)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func textConvertCustomEventName() {
    let convertCustomEventExpectation = expectation(description: #function)
    convertCustomEventExpectation.expectedFulfillmentCount = 2

    testTracker.did = { arg in
      XCTAssertEqual(arg.0, .convert)
      XCTAssertEqual(arg.filters.first, Constants.Filter.serialized)
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.userToken, nil)
      convertCustomEventExpectation.fulfill()
    }

    tracker.trackConversion(for: testFilter, eventName: Constants.customEventName)
    tracker.trackConversion(for: Constants.Filter.facet, attribute: Constants.Filter.attribute, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

}
