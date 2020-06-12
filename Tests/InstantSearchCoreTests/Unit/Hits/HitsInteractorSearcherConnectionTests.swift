//
//  HitsInteractorSearcherConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClientSwift
@testable import InstantSearchCore
import XCTest

class HitsInteractorSearcherConnectionTests: XCTestCase {

  func getInteractor(with infiniteScrollingController: InfiniteScrollable) -> HitsInteractor<JSON> {

    let paginator = Paginator<JSON>()

    let page1 = ["i1", "i2", "i3"].map { JSON.string($0) }
    paginator.pageMap = PageMap([1: page1])

    let interactor = HitsInteractor(settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
                                    paginationController: paginator,
                                    infiniteScrollingController: infiniteScrollingController)

    return interactor
  }

  func testConnect() {

    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]

    let searcher = SingleIndexSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)

    let connection: Connection = HitsInteractor.SingleIndexSearcherConnection(interactor: interactor,
                                                                              searcher: searcher)
    connection.connect()

    checkConnection(searcher: searcher,
                    interactor: interactor,
                    infiniteScrollingController: infiniteScrollingController,
                    isConnected: true)
  }

  func testDisconnect() {

    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]

    let searcher = SingleIndexSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)

    let connection: Connection = HitsInteractor.SingleIndexSearcherConnection(interactor: interactor,
                                                                              searcher: searcher)
    connection.connect()
    connection.disconnect()

    checkConnection(searcher: searcher,
                    interactor: interactor,
                    infiniteScrollingController: infiniteScrollingController,
                    isConnected: false)

  }

  func testConnectMethod() {

    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]

    let searcher = SingleIndexSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)

    interactor.connectSearcher(searcher)

    checkConnection(searcher: searcher,
                    interactor: interactor,
                    infiniteScrollingController: infiniteScrollingController,
                    isConnected: true)

  }

  func checkConnection(searcher: SingleIndexSearcher,
                       interactor: HitsInteractor<JSON>,
                       infiniteScrollingController: TestInfiniteScrollingController,
                       isConnected: Bool) {
    if isConnected {
      XCTAssertTrue(searcher === infiniteScrollingController.pageLoader)
    } else {
      XCTAssertNil(infiniteScrollingController.pageLoader)
    }

    let queryChangedExpectation = expectation(description: "query changed")
    queryChangedExpectation.isInverted = !isConnected

    interactor.onRequestChanged.subscribe(with: self) { _, _ in
      queryChangedExpectation.fulfill()
    }

    searcher.query = "query"
    searcher.indexQueryState.query.page = 0
    infiniteScrollingController.pendingPages = [0]

    let resultsUpdatedExpectation = expectation(description: "results updated")
    resultsUpdatedExpectation.isInverted = !isConnected

    interactor.onResultsUpdated.subscribe(with: self) { _, _ in
      resultsUpdatedExpectation.fulfill()
      XCTAssertTrue(infiniteScrollingController.pendingPages.isEmpty)
    }

    let searchResponse = SearchResponse(hits: [Hit(object: ["field": "value"])])
    searcher.onResults.fire(searchResponse)

    infiniteScrollingController.pendingPages = [0]
    searcher.onError.fire((searcher.indexQueryState.query, NSError()))

    if isConnected {
      XCTAssertTrue(infiniteScrollingController.pendingPages.isEmpty)
    } else {
      XCTAssertFalse(infiniteScrollingController.pendingPages.isEmpty)
    }

    waitForExpectations(timeout: 2, handler: nil)
  }

}
