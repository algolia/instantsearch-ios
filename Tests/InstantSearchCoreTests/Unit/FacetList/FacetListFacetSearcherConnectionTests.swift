//
//  FacetListFacetSearcherConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetListFacetSearcherConnectionTests: XCTestCase {

  let facets: [Facet] = .init(prefix: "v", count: 3)

  var results: FacetSearcher.SearchResult {
    return try! FacetSearcher.SearchResult(json: ["facetHits": try! JSON(facets), "exhaustiveFacetsCount": true, "processingTimeMS": 1])
  }

  func testConnect() {

    let interactor = FacetListInteractor(selectionMode: .single)
    let searcher = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "facet")

    let connection = FacetListInteractor.FacetSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()

    check(interactor: interactor, searcher: searcher, isConnected: true)

  }

  func testConnectFunction() {

    let interactor = FacetListInteractor(selectionMode: .single)
    let searcher = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "facet")

    interactor.connectFacetSearcher(searcher)

    check(interactor: interactor, searcher: searcher, isConnected: true)

  }

  func testDisconnect() {

    let interactor = FacetListInteractor(selectionMode: .single)
    let searcher = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "facet")

    let connection = FacetListInteractor.FacetSearcherConnection(interactor: interactor, searcher: searcher)
    connection.connect()
    connection.disconnect()

    check(interactor: interactor, searcher: searcher, isConnected: false)

  }

  func check(interactor: FacetListInteractor,
             searcher: FacetSearcher,
             isConnected: Bool) {

    let itemsChangedExpectation = expectation(description: "items changed")
    itemsChangedExpectation.isInverted = !isConnected

    interactor.onItemsChanged.subscribe(with: self) { (test, receivedFacets) in
      XCTAssertEqual(test.facets, receivedFacets)
      itemsChangedExpectation.fulfill()
    }

    searcher.onResults.fire(results)

    waitForExpectations(timeout: 5, handler: .none)

  }

}
