//
//  HitsInteractorSearcherConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
@testable import InstantSearchCore
import XCTest

class HitsInteractorSearcherConnectionTests: XCTestCase {
  
  weak var disposableInteractor: HitsInteractor<JSON>?
  weak var disposableSearcher: HitsSearcher?
  
  func getInteractor(with infiniteScrollingController: InfiniteScrollable) -> HitsInteractor<JSON> {
    
    let paginator = Paginator<JSON>()
    
    let page1 = ["i1", "i2", "i3"].map { JSON.string($0) }
    paginator.pageMap = PageMap([1: page1])
    
    let interactor = HitsInteractor(settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
                                    paginationController: paginator,
                                    infiniteScrollingController: infiniteScrollingController)
    
    return interactor
  }
  
  func testLeak() {
    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]
    
    let searcher = HitsSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)
    
    disposableInteractor = interactor
    disposableSearcher = searcher
    
    let connection: Connection = HitsInteractor.HitsSearcherConnection(interactor: interactor,
                                                                       searcher: searcher)
    connection.connect()
  }
  
  override func tearDown() {
    
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableSearcher, "Leaked searcher")
  }
  
  func testConnect() {
    
    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]
    
    let searcher = HitsSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)
    
    let connection: Connection = HitsInteractor.HitsSearcherConnection(interactor: interactor,
                                                                       searcher: searcher)
    connection.connect()
    
    let tester = ConnectionTester(searcher: searcher,
                                  interactor: interactor,
                                  infiniteScrollingController: infiniteScrollingController,
                                  source: self)
    tester.check(isConnected: true)
    
  }
  
  func testDisconnect() {
    
    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]
    
    let searcher = HitsSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)
    
    let connection: Connection = HitsInteractor.HitsSearcherConnection(interactor: interactor,
                                                                       searcher: searcher)
    connection.connect()
    connection.disconnect()
    
    let tester = ConnectionTester(searcher: searcher,
                                  interactor: interactor,
                                  infiniteScrollingController: infiniteScrollingController,
                                  source: self)
    tester.check(isConnected: false)
    
  }
  
  func testConnectMethod() {
    
    let infiniteScrollingController = TestInfiniteScrollingController()
    infiniteScrollingController.pendingPages = [0, 2]
    
    let searcher = HitsSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let interactor = getInteractor(with: infiniteScrollingController)
    
    interactor.connectSearcher(searcher)
    
    let tester = ConnectionTester(searcher: searcher,
                                  interactor: interactor,
                                  infiniteScrollingController: infiniteScrollingController,
                                  source: self)
    tester.check(isConnected: true)
    
  }
  
}

extension HitsInteractorSearcherConnectionTests {
  
  class ConnectionTester {
    
    let searcher: HitsSearcher
    let interactor: HitsInteractor<JSON>
    let infiniteScrollingController: TestInfiniteScrollingController
    let source: XCTestCase
    
    init(searcher: HitsSearcher,
         interactor: HitsInteractor<JSON>,
         infiniteScrollingController: TestInfiniteScrollingController,
         source: XCTestCase) {
      self.searcher = searcher
      self.interactor = interactor
      self.infiniteScrollingController = infiniteScrollingController
      self.source = source
    }
    
    func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      testPageLoader(isConnected: isConnected, file: file, line: line)
      testQueryChanged(isConnected: isConnected, file: file, line: line)
      testResultsUpdated(isConnected: isConnected, file: file, line: line)
      testPendingPages(isConnected: isConnected, file: file, line: line)
      source.waitForExpectations(timeout: 2, handler: nil)
    }
    
    private func testPageLoader(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      if isConnected {
        XCTAssertTrue(searcher === infiniteScrollingController.pageLoader, file: file, line: line)
      } else {
        XCTAssertNil(infiniteScrollingController.pageLoader, file: file, line: line)
      }
    }
    
    private func testQueryChanged(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      let queryChangedExpectation = source.expectation(description: "query changed")
      queryChangedExpectation.isInverted = !isConnected
      
      interactor.onRequestChanged.subscribe(with: self) { _, _ in
        queryChangedExpectation.fulfill()
      }
      
      searcher.query = "query"
      searcher.indexQueryState.query.page = 0
      infiniteScrollingController.pendingPages = [0]
    }
    
    private func testResultsUpdated(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      let resultsUpdatedExpectation = source.expectation(description: "results updated")
      resultsUpdatedExpectation.isInverted = !isConnected
      
      interactor.onResultsUpdated.subscribe(with: self) { tester, _ in
        resultsUpdatedExpectation.fulfill()
        XCTAssertTrue(tester.infiniteScrollingController.pendingPages.isEmpty, file: file, line: line)
      }
      
      let searchResponse = SearchResponse(hits: [Hit(object: ["field": "value"])])
      searcher.onResults.fire(searchResponse)
    }
    
    private func testPendingPages(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {
      infiniteScrollingController.pendingPages = [0]
      let requestError = AbstractSearcher<AlgoliaSearchService>.RequestError(request: .init(indexName: searcher.indexQueryState.indexName, query: searcher.indexQueryState.query), error: NSError())
      searcher.onError.fire(requestError)
      
      if isConnected {
        XCTAssertTrue(infiniteScrollingController.pendingPages.isEmpty, file: file, line: line)
      } else {
        XCTAssertFalse(infiniteScrollingController.pendingPages.isEmpty, file: file, line: line)
      }
    }
    
  }
  
}
