//
//  HitsInteractorFilterStateConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class HitsInteractorFilterStateConnectionTests: XCTestCase {

  var interactor: HitsInteractor<JSON> {
    return HitsInteractor<JSON>(settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
          paginationController: .init(),
    infiniteScrollingController: TestInfiniteScrollingController())
  }

  var filterState: FilterState {
    return .init()
  }
  
  weak var disposableInteractor: HitsInteractor<JSON>?
  weak var disposableFilterState: FilterState?
  
  func testLeak() {
    let interactor = self.interactor
    let filterState = self.filterState
    
    disposableInteractor = interactor
    disposableFilterState = filterState

    let connection = HitsInteractorFilterStateConnection(interactor: interactor,
                                                         filterState: filterState)

    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableFilterState, "Leaked filterState")
  }

  func testConnection() {
    let interactor = self.interactor
    let filterState = self.filterState

    let connection = HitsInteractorFilterStateConnection(interactor: interactor,
                                                         filterState: filterState)

    connection.connect()
    HitsInteractorFilterStateConnectionTester(interactor: interactor,
                                              filterState: filterState,
                                              source: self).check(isConnected: true)
  }

  func testConnectionMethod() {
    let interactor = self.interactor
    let filterState = self.filterState

    interactor.connectFilterState(filterState)

    HitsInteractorFilterStateConnectionTester(interactor: interactor,
                                              filterState: filterState,
                                              source: self).check(isConnected: true)
  }

  func testDisconnection() {
    let interactor = self.interactor
    let filterState = self.filterState

    let connection = HitsInteractorFilterStateConnection(interactor: interactor,
                                                         filterState: filterState)

    connection.connect()
    connection.disconnect()
    HitsInteractorFilterStateConnectionTester(interactor: interactor,
                                              filterState: filterState,
                                              source: self).check(isConnected: false)
  }


}

class HitsInteractorFilterStateConnectionTester {
  
  let interactor: HitsInteractor<JSON>
  let filterState: FilterState
  let source: XCTestCase
  var requestChangedExpectedFulfillmentCount: Int = 1
  
  init(interactor: HitsInteractor<JSON>,
       filterState: FilterState,
       source: XCTestCase) {
    self.interactor = interactor
    self.filterState = filterState
    self.source = source
  }
  
  func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {

    let requestChangedExpectation = source.expectation(description: "change query when filter state changed")
    requestChangedExpectation.expectedFulfillmentCount = requestChangedExpectedFulfillmentCount
    requestChangedExpectation.isInverted = !isConnected

    interactor.onRequestChanged.subscribe(with: self) { _, _ in
      requestChangedExpectation.fulfill()
    }

    filterState.add(Filter.Tag("t"), toGroupWithID: .and(name: ""))
    filterState.notifyChange()

    source.waitForExpectations(timeout: 2, handler: nil)

  }
  
}
