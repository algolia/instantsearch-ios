//
//  SelectableInteractorConnectorsTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class TestSelectableController<Item>: SelectableController {

  var item: Item?
  var onClick: ((Bool) -> Void)?

  var isSelected: Bool = false

  var onSelectedChanged: (() -> Void)?
  var onItemChanged: (() -> Void)?

  func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
    onSelectedChanged?()
  }

  func setItem(_ item: Item) {
    self.item = item
    onItemChanged?()
  }

  func toggle() {
    isSelected = !isSelected
    onClick?(isSelected)
  }

}

class SelectableInteractorConnectorsTests: XCTestCase {

  func testConnectFilterState() {

    let filterState = FilterState()

    let interactor = SelectableInteractor<Filter.Tag>(item: "tag")

    interactor.connectFilterState(filterState)

    // Interactor to FilterState

    XCTAssertTrue(filterState.filters.isEmpty)

    interactor.computeIsSelected(selecting: true)

    let groupID: FilterGroup.ID = .or(name: "_tags", filterType: .tag)

    XCTAssertTrue(filterState.filters.contains(Filter.Tag("tag"), inGroupWithID: groupID))

    interactor.computeIsSelected(selecting: false)

    XCTAssertTrue(filterState.filters.isEmpty)

    // FilterState to Interactor

    filterState.notify(.add(filter: Filter.Tag("tag"), toGroupWithID: groupID))

    XCTAssertTrue(interactor.isSelected)

  }

  func testConnectController() {

    let interactor = SelectableInteractor<Filter.Tag>(item: "tag")

    interactor.isSelected = true

    let controller = TestSelectableController<Filter.Tag>()

    let onChangeExp = expectation(description: "on change")
    onChangeExp.expectedFulfillmentCount = 3

    // Pre-selection transmission

    controller.onSelectedChanged = {
      XCTAssertTrue(controller.isSelected)
      onChangeExp.fulfill()
    }

    interactor.connectController(controller)

    // Interactor -> Controller

    controller.onSelectedChanged = {
      XCTAssertFalse(controller.isSelected)
      onChangeExp.fulfill()
    }

    interactor.isSelected = false

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testConnectControllerToggle() {
    let interactor = SelectableInteractor<Filter.Tag>(item: "tag")

    interactor.isSelected = false

    let controller = TestSelectableController<Filter.Tag>()

    interactor.connectController(controller)

    let selectedComputedExpectation = expectation(description: "selected computed")

    interactor.onSelectedComputed.subscribe(with: self) { _, isSelected in
      XCTAssertTrue(isSelected)
      selectedComputedExpectation.fulfill()
    }

    controller.toggle()

    waitForExpectations(timeout: 5, handler: nil)

  }

}
