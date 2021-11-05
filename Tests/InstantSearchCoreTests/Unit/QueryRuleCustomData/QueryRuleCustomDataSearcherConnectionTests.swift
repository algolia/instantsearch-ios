//
//  QueryRuleCustomDataSearcherConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 12/10/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class QueryRuleCustomDataSearcherConnectionTests: XCTestCase {
  
  struct TestModel: Codable {
    let number: Int
    let text: String
  }
  
  func testHitsSearcherConnection() {
    
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = QueryRuleCustomDataInteractor<TestModel>()
    
    interactor.connectSearcher(searcher)
    
    let response = SearchResponse().set(\.userData, to: [["number": 10, "text": "test"]])
    
    let itemChangedExpectation = expectation(description: "Item changed")
    
    interactor.onItemChanged.subscribe(with: self) { (test, model) in
      XCTAssertEqual(model?.number, 10)
      XCTAssertEqual(model?.text, "test")
      itemChangedExpectation.fulfill()
    }
    
    searcher.onResults.fire(response)
  
    waitForExpectations(timeout: 10, handler: nil)
    
  }
  
  @available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
  func testMultiIndexSearcherConnection() {
    
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["a", "b"])
    let interactor = QueryRuleCustomDataInteractor<TestModel>()

    interactor.connectSearcher(searcher, toQueryAtIndex: 1)
    
    let response1 = SearchResponse().set(\.userData, to: [["number": 10, "text": "test1"]])
    let response2 = SearchResponse().set(\.userData, to: [["number": 20, "text": "test2"]])
    
    let itemChangedExpectation = expectation(description: "Item changed")

    interactor.onItemChanged.subscribe(with: self) { (test, model) in
      XCTAssertEqual(model?.number, 20)
      XCTAssertEqual(model?.text, "test2")
      itemChangedExpectation.fulfill()
    }
    
    searcher.onResults.fire(.init(results: [response1, response2]))

    waitForExpectations(timeout: 10, handler: nil)
    
  }
  
}
