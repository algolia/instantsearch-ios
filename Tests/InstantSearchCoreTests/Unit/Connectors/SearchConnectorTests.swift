//
//  SearchConnectorTests.swift
//  
//
//  Created by Vladislav Fitc on 06/08/2020.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SearchConnectorTests: XCTestCase {
  
  struct ConnectorContainer {
    
    lazy var infiniteScrollingController: TestInfiniteScrollingController = {
      let controller = TestInfiniteScrollingController()
      controller.pendingPages = [0, 2]
      return controller
    }()
    
    let searcher = HitsSearcher(client: SearchClient(appID: "", apiKey: ""), indexName: "")
    let searchBoxInteractor = SearchBoxInteractor()
    let searchBoxController = TestSearchBoxController()
    lazy var hitsInteractor = getInteractor(with: infiniteScrollingController)
    let hitsController = TestHitsController<JSON>()
    let filterState = FilterState()
    
    lazy var connector = SearchConnector(searcher: searcher,
                                         searchBoxInteractor: searchBoxInteractor,
                                         searchBoxController: searchBoxController,
                                         hitsInteractor: hitsInteractor,
                                         hitsController: hitsController,
                                         filterState: filterState)
    
    func getInteractor(with infiniteScrollingController: InfiniteScrollable) -> HitsInteractor<JSON> {
      
      let paginator = Paginator<JSON>()
      
      let page1 = ["i1", "i2", "i3"].map { JSON.string($0) }
      paginator.pageMap = PageMap([1: page1])
      
      let interactor = HitsInteractor(settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
                                      paginationController: paginator,
                                      infiniteScrollingController: infiniteScrollingController)
      
      return interactor
    }
    
  }
  
  func testHitsInteractorSearcherConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = HitsInteractorSearcherConnectionTests.ConnectionTester(searcher: module.searcher,
                                                                        interactor: module.hitsInteractor,
                                                                        infiniteScrollingController: module.infiniteScrollingController,
                                                                        source: self)
    tester.check(isConnected: true)
  }
  
  func testHitsInteractorFilterStateConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = HitsInteractorFilterStateConnectionTester(interactor: module.hitsInteractor,
                                                           filterState: module.filterState,
                                                           source: self)
    tester.requestChangedExpectedFulfillmentCount = 2
    tester.check(isConnected: true)
  }
  
  func testHitsInteractorControllerConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = HitsInteractorControllerConnectionTester(interactor: module.hitsInteractor,
                                                          controller: module.hitsController,
                                                          source: self)
    tester.check(isConnected: true)
  }
  
  func testSearchBoxSearcherConnect() {
    // to complete when SingleIndexSearcher become abstract enough
  }
  
  func testSearchBoxControllerConnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    let tester = SearchBoxControllerConnectionTester(interactor: module.searchBoxInteractor,
                                                     controller: module.searchBoxController,
                                                     presetQuery: nil,
                                                     source: self)
    tester.check(isConnected: true)
  }
  
  func testDisconnect() {
    var module = ConnectorContainer()
    module.connector.connect()
    module.connector.disconnect()
    
    HitsInteractorFilterStateConnectionTester(interactor: module.hitsInteractor,
                                              filterState: module.filterState,
                                              source: self).check(isConnected: false)
    
    HitsInteractorControllerConnectionTester(interactor: module.hitsInteractor,
                                             controller: module.hitsController,
                                             source: self).check(isConnected: false)
    
    HitsInteractorSearcherConnectionTests.ConnectionTester(searcher: module.searcher,
                                                           interactor: module.hitsInteractor,
                                                           infiniteScrollingController: module.infiniteScrollingController,
                                                           source: self).check(isConnected: false)
    
    SearchBoxControllerConnectionTester(interactor: module.searchBoxInteractor,
                                        controller: module.searchBoxController,
                                        presetQuery: nil,
                                        source: self).check(isConnected: false)
  }
  
}
