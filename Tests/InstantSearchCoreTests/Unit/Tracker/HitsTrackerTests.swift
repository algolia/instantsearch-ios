//
//  HitsTrackerTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class HitsTrackerTests: XCTestCase {

  struct Constants {
    static let appID: ApplicationID = "test_app_id"
    static let apiKey: APIKey = "test_api_key"
    static let indexName: IndexName = "test index name"
    static let objectID: ObjectID = "test object id"
    static let eventName: EventName = "event name"
    static let customEventName: EventName = "custom event name"
    static let position = 10
    static let queryID: QueryID = "test query id"
    static let object: [String: JSON] = ["field": "value"]
  }

  let searcher = HitsSearcher(appID: Constants.appID, apiKey: Constants.apiKey, indexName: Constants.indexName)

  let testTracker = TestHitsTracker()

  lazy var tracker: HitsTracker = {
    let tracker = HitsTracker(eventName: Constants.eventName, searcher: .singleIndex(searcher), tracker: testTracker)
    tracker.queryID = Constants.queryID
    return tracker
  }()

  let hit = Hit<[String: JSON]>(object: Constants.object, objectID: Constants.objectID)

  func testClick() {
    let clickExpectation = expectation(description: #function)

    testTracker.didClick = { arg in
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDsWithPositions.first!.0, Constants.objectID)
      XCTAssertEqual(arg.objectIDsWithPositions.first!.1, Constants.position)
      XCTAssertEqual(arg.queryID, Constants.queryID)
      XCTAssertEqual(arg.userToken, nil)
      clickExpectation.fulfill()
    }

    tracker.trackClick(for: hit, position: Constants.position)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testClickCustomEventName() {
    let clickCustomEventExpectation = expectation(description: #function)

    testTracker.didClick = { arg in
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDsWithPositions.first!.0, Constants.objectID)
      XCTAssertEqual(arg.objectIDsWithPositions.first!.1, Constants.position)
      XCTAssertEqual(arg.queryID, Constants.queryID)
      XCTAssertEqual(arg.userToken, nil)
      clickCustomEventExpectation.fulfill()
    }

    tracker.trackClick(for: hit, position: Constants.position, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testView() {
    let viewExpectation = expectation(description: #function)

    testTracker.didView = { arg in
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDs.first, Constants.objectID)
      XCTAssertEqual(arg.userToken, nil)
      viewExpectation.fulfill()
    }

    tracker.trackView(for: hit)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testViewCustomEventName() {
    let viewCustomEventExpectation = expectation(description: #function)

    testTracker.didView = { arg in
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDs.first, Constants.objectID)
      XCTAssertEqual(arg.userToken, nil)
      viewCustomEventExpectation.fulfill()
    }

    tracker.trackView(for: hit, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func testConvert() {
    let convertExpectation = expectation(description: #function)

    testTracker.didConvert = { arg in
      XCTAssertEqual(arg.eventName, Constants.eventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDs.first, Constants.objectID)
      XCTAssertEqual(arg.queryID, Constants.queryID)
      XCTAssertEqual(arg.userToken, nil)
      convertExpectation.fulfill()
    }

    tracker.trackConvert(for: hit)
    waitForExpectations(timeout: 5, handler: .none)
  }

  func textConvertCustomEventName() {
    let convertCustomEventExpectation = expectation(description: #function)

    testTracker.didConvert = { arg in
      XCTAssertEqual(arg.eventName, Constants.customEventName)
      XCTAssertEqual(arg.indexName, Constants.indexName)
      XCTAssertEqual(arg.objectIDs.first!, Constants.objectID)
      XCTAssertEqual(arg.queryID, Constants.queryID)
      XCTAssertEqual(arg.userToken, nil)
      convertCustomEventExpectation.fulfill()
    }

    tracker.trackConvert(for: hit, eventName: Constants.customEventName)
    waitForExpectations(timeout: 5, handler: .none)
  }

}
