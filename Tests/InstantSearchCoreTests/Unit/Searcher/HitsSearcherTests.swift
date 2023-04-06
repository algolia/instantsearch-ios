//
//  HitsSearcherTests.swift
//
//
//  Created by Vladislav Fitc on 03/08/2020.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class HitsSearcherTests: XCTestCase {
  func testOnQueryChanged() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { _, newQuery in
      XCTAssertEqual(newQuery, "new query")
      exp.fulfill()
    }
    searcher.query = "new query"
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testOnIndexChanged() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Index change expectation")
    searcher.onIndexChanged.subscribe(with: self) { _, indexName in
      XCTAssertEqual(indexName, "index3")
      exp.fulfill()
    }
    searcher.request.indexName = "index3"
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testOnSearch() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Search expectation")
    searcher.onSearch.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testConditionalSearch() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Search expectation")
    exp.isInverted = true
    searcher.onSearch.subscribe(with: self) { _, _ in
      exp.fulfill()
    }
    searcher.shouldTriggerSearchForQuery = { query in
      return query.query.query ?? "" != ""
    }
    searcher.query = nil
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }

  func testTextualQueryChange() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")

    let exp1 = expectation(description: "Request changed expectation")

    searcher.onRequestChanged.subscribe(with: self) { _, _ in
      exp1.fulfill()
    }

    let exp2 = expectation(description: "Query changed expectation")

    searcher.onQueryChanged.subscribe(with: self) { _, _ in
      exp2.fulfill()
    }

    searcher.request.query.query = "1"

    waitForExpectations(timeout: 2, handler: .none)
  }

  func testIndexChange() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "index1")

    let exp1 = expectation(description: "Request changed expectation")

    searcher.onRequestChanged.subscribe(with: self) { _, _ in
      exp1.fulfill()
    }

    let exp2 = expectation(description: "Index changed expectation")

    searcher.onIndexChanged.subscribe(with: self) { _, _ in
      exp2.fulfill()
    }

    searcher.request.indexName = "index2"

    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testAutomaticHitsViewTracking() {
    let searcher = HitsSearcher(appID: "test_app_id",
                                apiKey: "test_api_key",
                                indexName: "test_index_name")

    let testHitsTracker = TestHitsTracker()
    
    testHitsTracker.didView = { arg in
      XCTAssertEqual(arg.eventName, "Hits Viewed")
      XCTAssertEqual(arg.indexName, "test_index_name")
      XCTAssertEqual(arg.objectIDs, ["id1", "id2", "id3"])
    }
    searcher.hitsTracker = HitsTracker(eventName: "test event name",
                                       searcher: .singleIndex(searcher),
                                       tracker: testHitsTracker)
    let rawHits: [JSON] = [
      [
        "objectID": "id1",
        "title": "object1"
      ],
      [
        "objectID": "id2",
        "title": "object2"
      ],
      [
        "objectID": "id3",
        "title": "object3"
      ]
    ]
    
    let hits = try! rawHits.map(Hit<JSON>.init)
    searcher.onResults.fire(SearchResponse(hits: hits))
  }
  
}
