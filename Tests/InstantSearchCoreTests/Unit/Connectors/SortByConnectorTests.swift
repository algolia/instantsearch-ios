//
//  SortByConnectorTests.swift
//  
//
//  Created by Vladislav Fitc on 14/12/2020.
//

import Foundation
@testable import InstantSearchCore
import AlgoliaSearchClient
import XCTest

class SortByConnectorTests: XCTestCase {
  
  var searcher: HitsSearcher!
  var controller: TestSelectableSegmentController!
  var connector: SortByConnector!
  
  override func setUp() {
    searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    controller = TestSelectableSegmentController()
    connector = SortByConnector(searcher: searcher,
                                indicesNames: ["Index1", "Index2", "Index3"],
                                selected: 0,
                                controller: controller)
  }
  
  func testSetItemsInteractorToController() {
    let itemsChangedExpectation = expectation(description: "Items changed")
    controller.onItemsChanged = {
      XCTAssertEqual(self.controller.items, [0: "Index4", 1: "Index5", 2: "Index6"])
      itemsChangedExpectation.fulfill()
    }
    connector.indicesNames = ["Index4", "Index5", "Index6"]
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testSelectionControllerToInteractor() {
    controller.clickItem(withKey: 2)
    XCTAssertEqual(connector.selectedIndexName, "Index3")
  }
  
  func testSelectionInteractorToController() {
    let selectionChangedExpectation = expectation(description: "Selection changed")
    
    controller.onSelectedChanged = {
      XCTAssertEqual(self.controller.selected, 1)
      selectionChangedExpectation.fulfill()
    }
    connector.selectedIndexName = "Index2"

    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
