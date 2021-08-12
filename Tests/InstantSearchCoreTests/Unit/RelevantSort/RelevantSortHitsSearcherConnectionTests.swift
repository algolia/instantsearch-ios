//
//  RelevantSortHitsSearcherConnectionTests.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class RelevantSortHitsSearcherConnectionTests: XCTestCase {
  
  weak var disposableSearcher: HitsSearcher?
  weak var disposableInteractor: RelevantSortInteractor?
  
  func testLeak() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    disposableSearcher = searcher
    disposableInteractor = interactor
    
    interactor.connectSearcher(searcher)
  }
  
  override func tearDown() {
    XCTAssertNil(disposableSearcher, "Leaked searcher")
    XCTAssertNil(disposableInteractor, "Leaked interactor")
  }

  
  func testConnect() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    let connection = RelevantSortInteractor.HitsSearcherConnection(interactor: interactor, searcher: searcher)
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
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
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
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)
    
    let connection = RelevantSortInteractor.HitsSearcherConnection(interactor: interactor, searcher: searcher)
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
