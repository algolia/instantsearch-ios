//
//  SingleIndexSearcherTests.swift
//  
//
//  Created by Vladislav Fitc on 03/08/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class SingleIndexSearcherTests: XCTestCase {
  
  func testOnQueryChanged() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { (test, newQuery) in
      XCTAssertEqual(newQuery, "new query")
      exp.fulfill()
    }
    searcher.query = "new query"
    waitForExpectations(timeout: 10, handler: .none)
  }
  
  func testOnIndexChanged() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "")
    searcher.onIndexChanged.subscribe(with: self) { (test, indexName) in
      XCTAssertEqual(indexName, "index3")
      exp.fulfill()
    }
    searcher.indexQueryState.indexName = "index3"
    waitForExpectations(timeout: 10, handler: .none)
  }

}
