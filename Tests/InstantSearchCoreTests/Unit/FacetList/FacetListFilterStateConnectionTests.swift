//
//  FacetListFilterStateConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetListFilterStateConnectionTests: XCTestCase {

  let attribute: Attribute = "Test Attribute"
  let groupName = "Test group"
  let facets: [Facet] = .init(prefix: "v", count: 4)

  func testConnect() {
    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let filterState = FilterState()

    let connection = FacetList.FilterStateConnection(interactor: interactor,
                                                     filterState: filterState,
                                                     attribute: attribute,
                                                     operator: .and,
                                                     groupName: groupName)
    connection.connect()

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: true)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: true)
  }

  func testConnectFunction() {

    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let filterState = FilterState()

    interactor.connectFilterState(filterState, with: attribute, operator: .and, groupName: groupName)

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: true)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: true)
  }

  func testDisconnect() {

    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let filterState = FilterState()

    let connection = FacetList.FilterStateConnection(interactor: interactor,
                                                     filterState: filterState,
                                                     attribute: attribute,
                                                     operator: .and,
                                                     groupName: groupName)
    connection.connect()
    connection.disconnect()

    checkConnection(interactor: interactor,
                    filterState: filterState,
                    isConnected: false)
    checkBackConnection(interactor: interactor,
                        filterState: filterState,
                        isConnected: false)
  }

  func checkConnection(interactor: FacetListInteractor,
                       filterState: FilterState,
                       isConnected: Bool) {

    let selectedIndex = 2

    let selectionsChangedExpectation = expectation(description: "selection changed expectation")
    selectionsChangedExpectation.isInverted = !isConnected

    interactor.onSelectionsChanged.subscribe(with: self) { (test, selections) in
      XCTAssertEqual(selections, [test.facets[selectedIndex].value])
      selectionsChangedExpectation.fulfill()
    }

    filterState[and: groupName].removeAll()
    let facetFilter = Filter.Facet(attribute: attribute, stringValue: facets[selectedIndex].value)
    filterState[and: groupName].add(facetFilter)
    filterState.notifyChange()

    waitForExpectations(timeout: 5) { _ in
      interactor.onSelectionsChanged.cancelSubscription(for: self)
    }

  }

  func checkBackConnection(interactor: FacetListInteractor,
                           filterState: FilterState,
                           isConnected: Bool) {

    let selectedIndex = 1

    let filterStateChangeExpectation = expectation(description: "filter state change")
    filterStateChangeExpectation.isInverted = !isConnected

    filterState.onChange.subscribe(with: self) { (test, filterContainer) in
      let facetFilter = Filter.Facet(attribute: test.attribute, stringValue: test.facets[selectedIndex].value)
      XCTAssertTrue(filterContainer[and: test.groupName].contains(facetFilter))
      filterStateChangeExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: facets[selectedIndex].value)

    waitForExpectations(timeout: 5) { _ in
      filterState.onChange.cancelSubscription(for: self)
    }

  }

}
