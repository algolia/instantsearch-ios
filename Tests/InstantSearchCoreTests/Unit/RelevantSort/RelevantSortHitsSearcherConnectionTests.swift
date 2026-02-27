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
    let searcher = HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
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
    let searcher = HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)

    let connection = RelevantSortInteractor.HitsSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()

    // In v9, we use nbSortedHits to determine relevant sort state (appliedRelevancyStrictness is removed)
    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)

    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: nil))
    XCTAssertEqual(interactor.item, .none)

    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { _, request in
      XCTAssertEqual(request.query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)

    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { _, request in
      XCTAssertEqual(request.query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }

  func testConnectMethod() {
    let searcher = HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)

    interactor.connectSearcher(searcher)

    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)

    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: nil))
    XCTAssertEqual(interactor.item, .none)

    let relevancyPriorityExpectation = expectation(description: "Relevancy priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { _, request in
      XCTAssertEqual(request.query.relevancyStrictness, 100)
      relevancyPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)

    let hitsCountPriorityExpectation = expectation(description: "Hits count priority")
    searcher.onRequestChanged.subscribeOnce(with: self) { _, request in
      XCTAssertEqual(request.query.relevancyStrictness, 0)
      hitsCountPriorityExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }

  func testDisconnect() {
    let searcher = HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = RelevantSortInteractor(priority: .relevancy)

    let connection = RelevantSortInteractor.HitsSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    connection.disconnect()

    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: nil))
    XCTAssertEqual(interactor.item, .relevancy)

    searcher.onResults.fire(makeSearchResponse().set(\.nbSortedHits, to: 100))
    XCTAssertEqual(interactor.item, .relevancy)

    let searchRequestExpectation = expectation(description: "Search request")
    searchRequestExpectation.isInverted = true
    searcher.onRequestChanged.subscribeOnce(with: self) { _, _ in
      searchRequestExpectation.fulfill()
    }

    interactor.toggle()
    waitForExpectations(timeout: 2, handler: nil)
  }
}
