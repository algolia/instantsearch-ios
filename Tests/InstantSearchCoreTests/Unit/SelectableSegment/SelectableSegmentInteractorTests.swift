//
//  SelectableSegmentInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SelectableSegmentInteractorTests: XCTestCase {

  typealias VM = SelectableSegmentInteractor<String, String>

  func testConstruction() {

    let interactor = VM(items: ["k1": "i1", "k2": "i2", "k3": "i3"])

    XCTAssertEqual(interactor.items, ["k1": "i1", "k2": "i2", "k3": "i3"])
    XCTAssertNil(interactor.selected)

  }

  func testSwitchItems() {

    let interactor = VM(items: ["k1": "i1", "k2": "i2", "k3": "i3"])

    let switchItemsExpectation = expectation(description: "switch items")

    interactor.onItemsChanged.subscribe(with: self) { _, newItems in
      XCTAssertEqual(newItems, ["k4": "i4"])
      switchItemsExpectation.fulfill()
    }

    interactor.items = ["k4": "i4"]

    waitForExpectations(timeout: 2, handler: nil)

  }

  func testSelection() {

    let interactor = VM(items: ["k1": "i1", "k2": "i2", "k3": "i3"])

    let selectionExpectation = expectation(description: "selection")

    interactor.onSelectedChanged.subscribe(with: self) { _, selectedKey in
      XCTAssertEqual(selectedKey, "k3")
      selectionExpectation.fulfill()
    }

    interactor.selected = "k3"

    XCTAssertEqual(interactor.selected, "k3")

    waitForExpectations(timeout: 2, handler: nil)

  }

  func testSelectionComputed() {

    let interactor = VM(items: ["k1": "i1", "k2": "i2", "k3": "i3"])

    let selectionComputedExpectation = expectation(description: "selection computed")

    interactor.onSelectedComputed.subscribe(with: self) { _, computedSelection in
      XCTAssertEqual(computedSelection, "k3")
      selectionComputedExpectation.fulfill()
    }

    interactor.computeSelected(selecting: "k3")

    waitForExpectations(timeout: 2, handler: .none)

  }

  func nilSelectedComputedTest() {
    let interactor = VM(items: ["k1": "i1", "k2": "i2", "k3": "i3"])

    let selectionComputedExp = expectation(description: "selection computed")

    interactor.onSelectedComputed.subscribe(with: self) { _, computedSelection in
      XCTAssertNil(computedSelection)
      selectionComputedExp.fulfill()
    }

    interactor.computeSelected(selecting: nil)

    waitForExpectations(timeout: 2, handler: .none)
  }

}
