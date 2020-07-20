//
//  SelectableListInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class SelectableListInteractorTests: XCTestCase {

  typealias VM = SelectableListInteractor<String, String>

  func testConstruction() {

    let interactor = VM(items: [], selectionMode: .single)

    XCTAssert(interactor.items.isEmpty)
    XCTAssertEqual(interactor.selectionMode, .single)

    let anotherInteractor = VM(items: ["s1", "s2"], selectionMode: .multiple)

    XCTAssertEqual(anotherInteractor.items, ["s1", "s2"])
    XCTAssertEqual(anotherInteractor.selectionMode, .multiple)

  }

  func testSwitchItems() {

    let interactor = VM(items: [], selectionMode: .single)

    let items = ["s1", "s2", "s3"]
    let switchItemsExpectation = expectation(description: "switch items")

    interactor.onItemsChanged.subscribe(with: self) { _, newItems in
      XCTAssertEqual(newItems, items)
      switchItemsExpectation.fulfill()
    }

    interactor.items = items

    waitForExpectations(timeout: 2, handler: .none)
  }

  func testOnSelectionsChanged() {
    let interactor = VM(items: ["s1", "s2", "s3"], selectionMode: .single)

    let selections = Set(["s2"])
    let selectionChangedExpectatiom = expectation(description: "selection")

    interactor.onSelectionsChanged.subscribe(with: self) { _, dispatchedSelections in
      XCTAssertEqual(dispatchedSelections, selections)
      selectionChangedExpectatiom.fulfill()
    }

    interactor.selections = selections

    waitForExpectations(timeout: 2, handler: .none)
  }

  func testOnSelectionsComputedSingle() {

    let interactor = VM(items: ["s1", "s2", "s3"], selectionMode: .single)
    interactor.selections = ["s2"]
    let deselectionExpectation = expectation(description: "deselection")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssert(dispatchedSelections.isEmpty)
      deselectionExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s2")

    waitForExpectations(timeout: 2, handler: .none)

    interactor.onSelectionsComputed.cancelAllSubscriptions()

    let selectionExpectation  = expectation(description: "selection expectation")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssertEqual(dispatchedSelections, ["s1"])
      selectionExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s1")

    waitForExpectations(timeout: 2, handler: .none)

    interactor.onSelectionsComputed.cancelAllSubscriptions()

    let replacementExpectation  = expectation(description: "replacement expectation")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssertEqual(dispatchedSelections, ["s3"])
      replacementExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s3")

    waitForExpectations(timeout: 2, handler: .none)

  }

  func testOnSelectionsComputedMultiple() {

    let interactor = VM(items: ["s1", "s2", "s3"], selectionMode: .multiple)
    interactor.selections = ["s2"]
    let deselectionExpectation = expectation(description: "deselection expectation")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssert(dispatchedSelections.isEmpty)
      deselectionExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s2")

    waitForExpectations(timeout: 2, handler: .none)

    interactor.onSelectionsComputed.cancelAllSubscriptions()

    let selectionExpectation = expectation(description: "selection expectation")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssertEqual(dispatchedSelections, ["s1", "s2"])
      selectionExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s1")

    waitForExpectations(timeout: 2, handler: .none)

    interactor.onSelectionsComputed.cancelAllSubscriptions()

    let additionExpectation = expectation(description: "addition expectation")

    interactor.onSelectionsComputed.subscribe(with: self) { _, dispatchedSelections in
      XCTAssertEqual(dispatchedSelections, ["s2", "s3"])
      additionExpectation.fulfill()
    }

    interactor.computeSelections(selectingItemForKey: "s3")

    waitForExpectations(timeout: 2, handler: .none)

  }

}
