//
//  SelectableListInteractorFilterConnectorsTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SelectableListInteractorFilterConnectorsTests: XCTestCase {

  func testConstructors() {

    let facetFilterListInteractor = FilterListInteractor<Filter.Facet>()
    XCTAssertEqual(facetFilterListInteractor.selectionMode, .multiple)

    let numericFilterListInteractor = FilterListInteractor<Filter.Numeric>()
    XCTAssertEqual(numericFilterListInteractor.selectionMode, .single)

    let tagFilterListInteractor = FilterListInteractor<Filter.Tag>()
    XCTAssertEqual(tagFilterListInteractor.selectionMode, .multiple)

  }

  func testFilterStateConnector() {

    let interactor = FilterListInteractor<Filter.Tag>()

    interactor.items = [
      "tag1", "tag2", "tag3"
    ]

    let filterState = FilterState()

    filterState.notify(.add(filter: Filter.Tag(value: "tag3"), toGroupWithID: .or(name: "", filterType: .tag)))

    interactor.connectFilterState(filterState, operator: .or)

    // FilterState -> Interactor preselection

    XCTAssertEqual(interactor.selections, ["tag3"])

    // FilterState -> Interactor

    filterState.notify(.add(filter: Filter.Tag(value: "tag1"), toGroupWithID: .or(name: "", filterType: .tag)))

    XCTAssertEqual(interactor.selections, ["tag1", "tag3"])

    // Interactor -> FilterState

    interactor.computeSelections(selectingItemForKey: "tag2")

    XCTAssertTrue(filterState.contains(Filter.Tag(value: "tag2"), inGroupWithID: .or(name: "", filterType: .tag)))

  }

  class TestController<F: FilterType>: SelectableListController {

    typealias Item = F

    var onClick: ((F) -> Void)?
    var didReload: (() -> Void)?

    var selectableItems: [(item: F, isSelected: Bool)] = []

    func setSelectableItems(selectableItems: [(item: F, isSelected: Bool)]) {
      self.selectableItems = selectableItems
    }

    func reload() {
      didReload?()
    }

    func clickOn(_ item: F) {
      onClick?(item)
    }

  }

  func testControllerConnector() {

    let interactor = FilterListInteractor<Filter.Tag>()
    let controller = TestController<Filter.Tag>()

    interactor.items = ["tag1", "tag2", "tag3"]
    interactor.selections = ["tag2"]

    interactor.connectController(controller)

    // Test preselection

    XCTAssertEqual(controller.selectableItems.map { $0.0 }, [
      Filter.Tag(value: "tag1"),
      Filter.Tag(value: "tag2"),
      Filter.Tag(value: "tag3")
    ])

    XCTAssertEqual(controller.selectableItems.map { $0.1 }, [
      false,
      true,
      false
    ])

    // Items change

    let itemsChangedReloadExpectation = expectation(description: "items changed reload expectation")

    controller.didReload = {

      XCTAssertEqual(controller.selectableItems.map { $0.0 }, [
        Filter.Tag(value: "tag1"),
        Filter.Tag(value: "tag2"),
        Filter.Tag(value: "tag3"),
        Filter.Tag(value: "tag4")
      ])

      XCTAssertEqual(controller.selectableItems.map { $0.1 }, [
        false,
        true,
        false,
        false
      ])

      itemsChangedReloadExpectation.fulfill()
    }

    interactor.items = ["tag1", "tag2", "tag3", "tag4"]

    waitForExpectations(timeout: 2, handler: nil)

    // Selection change

    let selectionsChangedReloadExpectation = expectation(description: "selections changed reload expectation")

    controller.didReload = {

      XCTAssertEqual(controller.selectableItems.map { $0.0 }, [
        Filter.Tag(value: "tag1"),
        Filter.Tag(value: "tag2"),
        Filter.Tag(value: "tag3"),
        Filter.Tag(value: "tag4")
        ])

      XCTAssertEqual(controller.selectableItems.map { $0.1 }, [
        false,
        false,
        true,
        true
      ])

      selectionsChangedReloadExpectation.fulfill()
    }

    interactor.selections = ["tag3", "tag4"]

    waitForExpectations(timeout: 2, handler: nil)

    // Selection computation on click

    let selectionsComputedExpectation = expectation(description: "selections computed")

    interactor.onSelectionsComputed.subscribe(with: self) { _, selectedTags in
      XCTAssertEqual(selectedTags, ["tag1", "tag3", "tag4"])
      selectionsComputedExpectation.fulfill()
    }

    controller.clickOn("tag1")

    waitForExpectations(timeout: 2, handler: nil)

  }

}
