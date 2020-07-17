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
    checkConnection(interactor: interactor, filterState: filterState, isConnected: true)
  }

  func testConnectionMethod() {
    let interactor = self.interactor
    let filterState = self.filterState

    interactor.connectFilterState(filterState)

    checkConnection(interactor: interactor, filterState: filterState, isConnected: true)
  }

  func testDisconnection() {
    let interactor = self.interactor
    let filterState = self.filterState

    let connection = HitsInteractorFilterStateConnection(interactor: interactor,
                                                         filterState: filterState)

    connection.connect()
    connection.disconnect()
    checkConnection(interactor: interactor, filterState: filterState, isConnected: false)
  }

  func checkConnection(interactor: HitsInteractor<JSON>,
                       filterState: FilterState,
                       isConnected: Bool) {

    let exp = expectation(description: "change query when filter state changed")
    exp.isInverted = !isConnected

    interactor.onRequestChanged.subscribe(with: self) { _, _ in
      exp.fulfill()
    }

    filterState.add(Filter.Tag("t"), toGroupWithID: .and(name: ""))
    filterState.notifyChange()

    waitForExpectations(timeout: 2, handler: nil)

  }

}
