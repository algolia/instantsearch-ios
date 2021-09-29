//
//  AnswerSearcherTests.swift
//  
//
//  Created by Vladislav Fitc on 14/12/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class AnswersSearcherTests: XCTestCase {
  
  func testOnQueryChanged() {
    let searcher = AnswersSearcher(applicationID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Query change expectation")
    searcher.onQueryChanged.subscribe(with: self) { (test, newQuery) in
      XCTAssertEqual(newQuery, "new query")
      exp.fulfill()
    }
    searcher.query = "new query"
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testOnIndexChanged() {
    let searcher = AnswersSearcher(applicationID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Index change expectation")
    searcher.onIndexChanged.subscribe(with: self) { (test, indexName) in
      XCTAssertEqual(indexName, "index3")
      exp.fulfill()
    }
    searcher.request.indexName = "index3"
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testOnSearch() {
    let searcher = AnswersSearcher(applicationID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Search expectation")
    searcher.onSearch.subscribe(with: self) { (test, _) in
      exp.fulfill()
    }
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func testConditionalSearch() {
    let searcher = AnswersSearcher(applicationID: "", apiKey: "", indexName: "index1")
    let exp = expectation(description: "Search expectation")
    exp.isInverted = true
    searcher.onSearch.subscribe(with: self) { (test, _) in
      exp.fulfill()
    }
    searcher.shouldTriggerSearchForQuery = { query in
      return query.query.query ?? "" != ""
    }
    searcher.query = nil
    searcher.search()
    waitForExpectations(timeout: 2, handler: .none)
  }
  
  func connections() {
    let searcher = AnswersSearcher(applicationID: "", apiKey: "", indexName: "index1")
    let statsInteractor = StatsInteractor()
    statsInteractor.connectSearcher(searcher)
    
    let queryRuleCustomDataInteractor = QueryRuleCustomDataInteractor<JSON>()
    queryRuleCustomDataInteractor.connectSearcher(searcher)
    
    let numberInteractor = NumberInteractor(item: 1)
    numberInteractor.connect(searcher, attribute: "value")
    
    let numberRangeInteractor = NumberRangeInteractor(item: 1...10)
    numberRangeInteractor.connect(searcher, attribute: "rangeValue")
    
    let filterState = FilterState()
    searcher.connectFilterState(filterState)
    
    let segmentedInteractor = SortByInteractor(items: [1: "one", 2: "two"], selected: 1)
    segmentedInteractor.connectSearcher(searcher: searcher)
    
    let hitsInteractor = HitsInteractor<JSON>()
    hitsInteractor.connectSearcher(searcher)
  }
  
}
