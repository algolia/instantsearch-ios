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

  let attribute: Attribute = "Test Attribute"
  let facets: [Facet] = .init(prefix: "v", count: 3)
  
  weak var disposableSearcher: HitsSearcher?
  weak var disposableInteractor: FacetListInteractor?
  
  func testLeak() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
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

  func testConnect() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = FacetListInteractor()

    let connection = FacetListInteractor.HitsSearcherConnection(facetListInteractor: interactor, searcher: searcher, attribute: attribute)
    connection.connect()

    checkConnection(interactor: interactor,
                    searcher: searcher,
                    isConnected: true)
  }

  func testConnectMethod() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let interactor = FacetListInteractor()

    interactor.connectSearcher(searcher, with: attribute)

    checkConnection(interactor: interactor,
                    searcher: searcher,
                    isConnected: true)
  }

  func testDisconnect() {
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
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
    var results = SearchResponse(hits: [TestRecord<Int>]())
    results.disjunctiveFacets = [attribute: facets]

    let onItemsChangedExpectation = expectation(description: "on items changed")
    onItemsChangedExpectation.isInverted = !isConnected

    interactor.onItemsChanged.subscribe(with: self) { (test, facets) in
      XCTAssertEqual(test.facets, facets)
      onItemsChangedExpectation.fulfill()
    }

    searcher.onResults.fire(results)

    waitForExpectations(timeout: 5, handler: .none)
  }

}

extension SearchResponse {

  init<E: Encodable>(hits: [E]) {
    let hitsJSON: JSON = try! .array(hits.map(JSON.init))
    try! self.init(json: ["hits": hitsJSON])
  }

}

extension Hit where T == [String: JSON] {

  init(object: [String: JSON], objectID: ObjectID? = nil) {
    var mutableCopy = object
    let objectID = objectID ?? ObjectID(rawValue: UUID().uuidString)
    mutableCopy["objectID"] = .string(objectID.rawValue)
    try! self.init(json: .dictionary(mutableCopy))
  }

  static func withJSON(_ json: [String: JSON]) -> Self {
    .init(object: json)
  }

}
