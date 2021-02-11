//
//  DynamicSortToggleSearcherConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class DynamicSortToggleSingleIndexSearcherConnectionTests: XCTestCase {
  
  weak var disposableSearcher: SingleIndexSearcher?
  weak var disposableInteractor: DynamicSortToggleInteractor?
  
  func testLeak() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)
    
    disposableSearcher = searcher
    disposableInteractor = interactor
    
    interactor.connectSearcher(searcher)
  }
  
  override func tearDown() {
    XCTAssertNil(disposableSearcher, "Leaked searcher")
    XCTAssertNil(disposableInteractor, "Leaked interactor")
  }

  
  func testConnect() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)
    
    let connection = DynamicSortToggleInteractor.SingleIndexSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 0))
    XCTAssertEqual(interactor.item, .hitsCount)
    
    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { (_, request) in
      XCTAssertEqual(request.query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
    
    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { (_, request) in
      XCTAssertEqual(request.query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testConnectMethod() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)
    
    interactor.connectSearcher(searcher)
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 0))
    XCTAssertEqual(interactor.item, .hitsCount)
    
    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { (_, request) in
      XCTAssertEqual(request.query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
    
    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { (_, request) in
      XCTAssertEqual(request.query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testDisconnect() {
    let searcher = SingleIndexSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = DynamicSortToggleInteractor(priority: .relevancy)
    
    let connection = DynamicSortToggleInteractor.SingleIndexSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    connection.disconnect()
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 0))
    XCTAssertEqual(interactor.item, .relevancy)
    
    searcher.onResults.fire(SearchResponse().set(\.appliedRelevancyStrictness, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)
    
    let searchRequestExpectation = expectation(description: "Search request")
    searchRequestExpectation.isInverted = true
    searcher.onRequestChanged.subscribeOnce(with: self) { (_, request) in
      searchRequestExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)

  }
  
}
