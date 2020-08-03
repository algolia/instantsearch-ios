//
//  MultiIndexSearcherTests.swift
//  
//
//  Created by Vladislav Fitc on 03/08/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class MultiIndexSearcherTests: XCTestCase {
  
  func testOnQueryChanged() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["index1", "index2"])
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { (test, newQuery) in
      exp.fulfill()
    }
    searcher.query = ""
    waitForExpectations(timeout: 10, handler: .none)
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
    waitForExpectations(timeout: 10, handler: .none)
  }

}
