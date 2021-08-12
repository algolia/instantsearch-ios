//
//  RelevantSortMultiIndexSearcherConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 11/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

@available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
class RelevantSortMultiIndexSearcherConnectionTests: XCTestCase {
  
  weak var disposableSearcher: MultiIndexSearcher?
  weak var disposableInteractor: RelevantSortInteractor?
  
  func testLeak() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["a", "b"])
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    disposableSearcher = searcher
    disposableInteractor = interactor
    
    interactor.connectSearcher(searcher, queryIndex: 0)
  }
  
  override func tearDown() {
    XCTAssertNil(disposableSearcher, "Leaked searcher")
    XCTAssertNil(disposableInteractor, "Leaked interactor")
  }

  
  func testConnect() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["a", "b"])
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    let connection = RelevantSortInteractor.MultiIndexSearcherConnection(interactor: interactor, searcher: searcher, queryIndex: 0)
    connection.connect()
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 100)]))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 0)]))
    XCTAssertEqual(interactor.item, .hitsCount)
    
    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onSearch.subscribeOnce(with: self) { (_, _) in
      XCTAssertEqual(searcher.indexQueryStates[0].query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
    
    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onSearch.subscribeOnce(with: self) { (_, _) in
      XCTAssertEqual(searcher.indexQueryStates[0].query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testConnectMethod() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["a", "b"])
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    interactor.connectSearcher(searcher, queryIndex: 0)
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 100)]))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 0)]))
    XCTAssertEqual(interactor.item, .hitsCount)
    
    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onSearch.subscribeOnce(with: self) { (_, _) in
      XCTAssertEqual(searcher.indexQueryStates[0].query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
    
    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onSearch.subscribeOnce(with: self) { (_, _) in
      XCTAssertEqual(searcher.indexQueryStates[0].query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testDisconnect() {
    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["a", "b"])
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    let connection = RelevantSortInteractor.MultiIndexSearcherConnection(interactor: interactor, searcher: searcher, queryIndex: 0)
    connection.connect()
    connection.disconnect()
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 100)]))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchesResponse(results: [SearchResponse().set(\.appliedRelevancyStrictness, to: 0)]))
    XCTAssertEqual(interactor.item, .relevancy)
    
    let searchRequestExpectation = expectation(description: "Search request")
    searchRequestExpectation.isInverted = true
    searcher.onSearch.subscribeOnce(with: self) { (_, _) in
      searchRequestExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)

  }
  
}
