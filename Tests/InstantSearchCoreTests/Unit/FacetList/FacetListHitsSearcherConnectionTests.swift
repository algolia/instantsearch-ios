//
//  FacetListHitsSearcherConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetListHitsSearcherConnectionTests: XCTestCase {
  let attribute = "Test Attribute"
  let facets: [FacetHits] = .init(prefix: "v", count: 3)

  weak var disposableSearcher: HitsSearcher?
  weak var disposableInteractor: FacetListInteractor?

  func testLeak() throws {
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = FacetListInteractor()

    disposableSearcher = searcher
    disposableInteractor = interactor

    let connection = FacetListInteractor.HitsSearcherConnection(facetListInteractor: interactor, searcher: searcher, attribute: attribute)
    connection.connect()
  }

  override func tearDown() {
    XCTAssertNil(disposableSearcher, "Leaked searcher")
    XCTAssertNil(disposableInteractor, "Leaked interactor")
  }

  func testConnect() throws {
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = FacetListInteractor()

    let connection = FacetListInteractor.HitsSearcherConnection(facetListInteractor: interactor, searcher: searcher, attribute: attribute)
    connection.connect()

    checkConnection(interactor: interactor,
                    searcher: searcher,
                    isConnected: true)
  }

  func testConnectMethod() throws {
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = FacetListInteractor()

    interactor.connectSearcher(searcher, with: attribute)

    checkConnection(interactor: interactor,
                    searcher: searcher,
                    isConnected: true)
  }

  func testDisconnect() throws {
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = FacetListInteractor()

    let connection = FacetListInteractor.HitsSearcherConnection(facetListInteractor: interactor, searcher: searcher, attribute: attribute)
    connection.connect()
    connection.disconnect()

    checkConnection(interactor: interactor,
                    searcher: searcher,
                    isConnected: false)
  }

  func checkConnection(interactor: FacetListInteractor,
                       searcher: HitsSearcher,
                       isConnected: Bool) {
    var results = makeSearchResponse()
    let facetDictionary = Dictionary(uniqueKeysWithValues: facets.map { ($0.value, $0.count) })
    results.facets = [attribute: facetDictionary]

    let onItemsChangedExpectation = expectation(description: "on items changed")
    onItemsChangedExpectation.isInverted = !isConnected

    interactor.onItemsChanged.subscribe(with: self) { test, facets in
      XCTAssertEqual(Set(test.facets), Set(facets))
      onItemsChangedExpectation.fulfill()
    }

    searcher.onResults.fire(results)

    waitForExpectations(timeout: 5, handler: .none)
  }
}
