//
//  IndexNameSwitchInteractorTests.swift
//  
//
//  Created by Vladislav Fitc on 14/12/2020.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class IndexNameSwitchInteractorTests: XCTestCase {
  
  class TestIndexNameSwitchable: IndexNameSwitchable {
    
    var didSwitchIndex: ((IndexName) -> Void)?
    
    init(didSwitchIndex: ((IndexName) -> Void)? = nil) {
      self.didSwitchIndex = didSwitchIndex
    }
    
    func switchIndexName(to indexName: IndexName) {
      didSwitchIndex?(indexName)
    }
    
  }
  
  func testTargetConnection() {
    let indexSwitchExpectation = expectation(description: "switch index")
    let testSwitchable = TestIndexNameSwitchable { indexName in
      XCTAssertEqual(indexName, "Index1")
      indexSwitchExpectation.fulfill()
    }
    let interactor = IndexNameSwitchInteractor(items: [0: "Index0", 1: "Index1", 2: "Index2"])
    interactor.connect(testSwitchable)
    interactor.computeSelected(selecting: 1)
    waitForExpectations(timeout: 3, handler: nil)
  }
  
  func testControllerConnection() {
    let controller = TestSelectableSegmentController()
    let interactor = IndexNameSwitchInteractor(items: [0: "Index0", 1: "Index1", 2: "Index2"], selected: 1)
    
    let onChangeExp = expectation(description: "on change")
    onChangeExp.expectedFulfillmentCount = 4
    
    // Preselection
    
    controller.onItemsChanged = {
      XCTAssertEqual(controller.items, [0: "Index0", 1: "Index1", 2: "Index2"])
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
      XCTAssertEqual(controller.items, [0: "Index4", 1: "Index5", 2: "Index6"])
      onChangeExp.fulfill()
    }

    interactor.items = [0: "Index4", 1: "Index5", 2: "Index6"]

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
