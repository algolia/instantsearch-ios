//
//  CurrentFiltersFilterStateConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class CurrentFiltersFilterStateConnectionTests: XCTestCase {

  let groupName = "Test group"
  let filter = Filter.Facet(attribute: "Test Attribute", stringValue: "facet")

  func testConnect() {
    let interactor = CurrentFiltersInteractor()
    let filterState = FilterState()

    let connection = CurrentFiltersInteractor.FilterStateConnection(interactor: interactor,
                                                     filterState: filterState)
    connection.connect()

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: true)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: true)
  }

  func testConnectFunction() {

    let interactor = CurrentFiltersInteractor()
    let filterState = FilterState()

    interactor.connectFilterState(filterState)

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: true)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: true)
  }

  func testDisconnect() {

    let interactor = CurrentFiltersInteractor()
    let filterState = FilterState()

    let connection = CurrentFiltersInteractor.FilterStateConnection(interactor: interactor, filterState: filterState)

    connection.connect()
    connection.disconnect()

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: false)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: false)
  }

  func checkConnection(interactor: CurrentFiltersInteractor,
                       filterState: FilterState,
                       isConnected: Bool) {

    let itemsChangedExpectation = expectation(description: "items changed expectation")
    itemsChangedExpectation.isInverted = !isConnected

    interactor.onItemsChanged.subscribe(with: self) { (test, filtersAndIDs) in
      XCTAssertEqual(filtersAndIDs, [FilterAndID(filter: Filter(test.filter), id: .and(name: test.groupName))])
      itemsChangedExpectation.fulfill()
    }

    filterState[and: groupName].removeAll()
    filterState[and: groupName].add(filter)
    filterState.notifyChange()

    waitForExpectations(timeout: 5) { _ in
      interactor.onItemsChanged.cancelSubscription(for: self)
    }

  }

  func checkBackConnection(interactor: CurrentFiltersInteractor,
                           filterState: FilterState,
                           isConnected: Bool) {

    let filterStateChangeExpectation = expectation(description: "filter state change")
    filterStateChangeExpectation.isInverted = !isConnected

    filterState.onChange.subscribe(with: self) { (test, filterContainer) in
      XCTAssertTrue(filterContainer[and: test.groupName].contains(test.filter))
      filterStateChangeExpectation.fulfill()
    }

    interactor.add(item: FilterAndID(filter: Filter(filter), id: .and(name: groupName)))

    waitForExpectations(timeout: 5) { _ in
      filterState.onChange.cancelSubscription(for: self)
    }

  }

}
