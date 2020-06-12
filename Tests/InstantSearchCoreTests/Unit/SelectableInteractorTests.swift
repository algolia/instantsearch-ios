//
//  SelectableInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SelectableInteractorTests: XCTestCase {

  typealias VM = SelectableInteractor<String>

  func testConstruction() {

    let interactor = SelectableInteractor(item: "i")

    XCTAssertFalse(interactor.isSelected)
    XCTAssertEqual(interactor.item, "i")

  }

  func testSwitchItem() {

    let interactor = SelectableInteractor(item: "i")

    let switchItemExpectation = expectation(description: "item changed")

    interactor.onItemChanged.subscribe(with: self) { _, newItem in
      XCTAssertEqual(newItem, "o")
      switchItemExpectation.fulfill()
    }

    interactor.item = "o"

    waitForExpectations(timeout: 2, handler: nil)
  }

  func testSelection() {

    let interactor = SelectableInteractor(item: "i")

    let selectionExpectation = expectation(description: "item selected")
    let deselectionExpectation = expectation(description: "item deselected")

    interactor.onSelectedChanged.subscribe(with: self) { _, isSelected in
      if isSelected {
        selectionExpectation.fulfill()
      } else {
        deselectionExpectation.fulfill()
      }
    }

    interactor.isSelected = true
    interactor.isSelected = false

    waitForExpectations(timeout: 2, handler: nil)

  }

  func testSelectedComputed() {

    let interactor = SelectableInteractor(item: "i")

    let selectedComputedExpectation = expectation(description: "computed selected")

    interactor.onSelectedComputed.subscribe(with: self) { _, isSelected in
      XCTAssertEqual(isSelected, false)
      selectedComputedExpectation.fulfill()
    }

    interactor.computeIsSelected(selecting: false)

    waitForExpectations(timeout: 2, handler: nil)

  }

}
