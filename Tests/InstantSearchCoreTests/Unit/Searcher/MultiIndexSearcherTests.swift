//
//  MultiIndexSearcherTests.swift
//  
//
//  Created by Vladislav Fitc on 03/08/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
class MultiIndexSearcherTests: XCTestCase {
  
  func testOnQueryChanged() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["index1", "index2"])
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { (test, newQuery) in
      exp.fulfill()
    }
    searcher.query = ""
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testOnIndexChanged() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["index1", "index2"])
    let exp = expectation(description: "")
    searcher.onIndexChanged.subscribe(with: self) { (test, args) in
      let (index, indexName) = args
      XCTAssertEqual(index, 1)
      XCTAssertEqual(indexName, "index3")
      exp.fulfill()
    }
    searcher.indexQueryStates[1].indexName = "index3"
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testOnSearch() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let exp = expectation(description: "Search expectation")
    searcher.onSearch.subscribe(with: self) { (test, _) in
      exp.fulfill()
    }
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testConditionalSearch() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["i1", "i2"])
    let exp = expectation(description: "Search expectation")
    exp.isInverted = true
    searcher.onSearch.subscribe(with: self) { (test, _) in
      exp.fulfill()
    }
    searcher.shouldTriggerSearchForQueries = { queries in return queries[0].query ?? "" != "" }
    searcher.query = nil
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }


}
