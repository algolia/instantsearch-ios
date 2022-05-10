//
//  SelectableSegmentInteractorConnectorsTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import AlgoliaSearchClient
import XCTest

class SelectableSegmentInteractorConnectorsTests: XCTestCase {

  func testConnectSearcher() {

    let filterState = FilterState()
    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")

    let interactor = FilterMapInteractor<Filter.Tag>(items: [0: "t1", 1: "t2", 2: "t3"])
    interactor.connectSearcher(searcher, attribute: "tags")
    interactor.connectFilterState(filterState, attribute: "tags", operator: .or)

    XCTAssertTrue((searcher.request.query.facets ?? []).contains("tags"))

  }

  func testConnectFilterState() {

    let filterState = FilterState()
    let interactor = FilterMapInteractor<Filter.Tag>(items: [0: "t1", 1: "t2", 2: "t3"])

    interactor.connectFilterState(filterState, attribute: "tags", operator: .or)
    // Interactor -> FilterState

    interactor.computeSelected(selecting: 1)

    XCTAssertTrue(filterState.contains(Filter.Tag(value: "t2"), inGroupWithID: .or(name: "tags", filterType: .tag)))

    // FilterState -> Interactor

    filterState.notify(.remove(filter: Filter.Tag(value: "t2"), fromGroupWithID: .or(name: "tags", filterType: .tag)))

    XCTAssertNil(interactor.selected)

    filterState.notify(.add(filter: Filter.Tag(value: "t3"), toGroupWithID: .or(name: "tags", filterType: .tag)))

    XCTAssertEqual(interactor.selected, 2)

  }

  func testConnectController() {

    let interactor = FilterMapInteractor<Filter.Tag>(items: [0: "t1", 1: "t2", 2: "t3"])
    let controller = TestSelectableSegmentController()

    interactor.selected = 1

    let onChangeExp = expectation(description: "on change")
    onChangeExp.expectedFulfillmentCount = 5

    // Preselection

    controller.onItemsChanged = {
      XCTAssertEqual(controller.items, [0: "t1", 1: "t2", 2: "t3"])
      onChangeExp.fulfill()
    }

    controller.onSelectedChanged = {
      XCTAssertEqual(controller.selected, 1)
      onChangeExp.fulfill()
    }

    interactor.connectController(controller)

    // Interactor -> Controller

    controller.onSelectedChanged = {
      XCTAssertEqual(controller.selected, 2)
      onChangeExp.fulfill()
    }

    interactor.selected = 2

    controller.onItemsChanged = {
      XCTAssertEqual(controller.items, [0: "t4", 1: "t5", 2: "t6"])
      onChangeExp.fulfill()
    }

    interactor.items = [0: "t4", 1: "t5", 2: "t6"]

    // Controller -> Interactor

    let selectedComputedExpectation = expectation(description: "selected computed")

    interactor.onSelectedComputed.subscribe(with: self) { _, selected in
      XCTAssertEqual(selected, 0)
      selectedComputedExpectation.fulfill()
    }

    controller.clickItem(withKey: 0)

    waitForExpectations(timeout: 5, handler: nil)

  }

}
