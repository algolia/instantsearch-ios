//
//  StatsInteractorConnectorsTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 31/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore
import AlgoliaSearchClient
class StatsInteractorConnectorsTests: XCTestCase {

  class TestStatsController: ItemController {

    var didSetItem: ((Item) -> Void)?

    typealias Item = String

    func setItem(_ item: Item) {
      didSetItem?(item)
    }
  }

  func testConnectSearcher() {

    let vm = StatsInteractor()
    let results = SearchResponse(hits: [TestRecord<Int>]())
    let query = Query()

    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "", query: query)
    vm.connectSearcher(searcher)

    let exp = expectation(description: "on item changed")

    vm.onItemChanged.subscribe(with: self) { _, _ in
      exp.fulfill()
    }

    searcher.onResults.fire(results)

    waitForExpectations(timeout: 2, handler: .none)

  }

  func testConnectController() {

    let vm = StatsInteractor()

    let controller = TestStatsController()

    vm.connectController(controller, presenter: { _ in return "test string" })

    let exp = expectation(description: "did set item")

    controller.didSetItem = { string in
      XCTAssertEqual(string, "test string")
      exp.fulfill()
    }

    vm.item = SearchStats(totalHitsCount: 100, hitsPerPage: 10, pagesCount: 10, page: 0, processingTimeMS: 1, query: "q1")

    waitForExpectations(timeout: 2, handler: nil)

  }

}
