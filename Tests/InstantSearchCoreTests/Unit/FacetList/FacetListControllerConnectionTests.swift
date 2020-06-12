//
//  FacetListControllerConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetListControllerConnectionTests: XCTestCase {

  let attribute: Attribute = "Test Attribute"
  let groupName = "Test group"

  let facets: [Facet] = .init(prefix: "f", count: 3)
  let facetsWithAddition: [Facet] = .init(prefix: "f", count: 4)

  func testConnect() {

    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let controller = TestFacetListController()

    let connection = FacetList.ControllerConnection(facetListInteractor: interactor, controller: controller, presenter: FacetListPresenter())
    connection.connect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)
  }

  func testConnectFunction() {

    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let controller = TestFacetListController()

    interactor.connectController(controller)

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)

  }

  func testDisconnect() {
    let interactor = FacetListInteractor(facets: facets, selectionMode: .single)
    let controller = TestFacetListController()

    let connection = FacetList.ControllerConnection(facetListInteractor: interactor, controller: controller, presenter: FacetListPresenter())
    connection.connect()
    connection.disconnect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: false)
  }

  func checkConnection(interactor: FacetListInteractor,
                       controller: TestFacetListController,
                       isConnected: Bool) {
    checkSelectionsComputedOnClick(interactor: interactor,
                                   controller: controller,
                                   isConnected: isConnected)
    checkUpdateControllerWhenItemsChanged(interactor: interactor,
                                          controller: controller,
                                          isConnected: isConnected)
    checkUpdateControllerWhenSelectionsChanged(interactor: interactor,
                                             controller: controller,
                                             isConnected: isConnected)
  }

  func checkSelectionsComputedOnClick(interactor: FacetListInteractor,
                                      controller: TestFacetListController,
                                      isConnected: Bool) {

    let selectionsComputedExpectation = expectation(description: "selections computed")
    selectionsComputedExpectation.isInverted = !isConnected

    interactor.onSelectionsComputed.subscribe(with: self) { test, selections in
      XCTAssertEqual(selections, [test.facets[2].value])
      selectionsComputedExpectation.fulfill()
    }

    controller.onClick?(facets[2])

    waitForExpectations(timeout: 5, handler: .none)

  }

  func checkUpdateControllerWhenItemsChanged(interactor: FacetListInteractor,
                                             controller: TestFacetListController,
                                             isConnected: Bool) {

    let selectedIndex = 1

    interactor.selections = [facets[selectedIndex].value]
    let reloadExpectation = expectation(description: "reload expectation")
    reloadExpectation.isInverted = !isConnected
    reloadExpectation.expectedFulfillmentCount = 3
    controller.didReload = {
      let selections: [Bool] = (0...3).compactMap { i in
        return controller.selectableItems.first { $0.item.value == "f\(i)" }.flatMap { $0.isSelected }
      }
      XCTAssertEqual(selections, (0...3).map { $0 == selectedIndex })
      reloadExpectation.fulfill()
    }

    interactor.items = facetsWithAddition

    waitForExpectations(timeout: 5, handler: .none)

  }

  func checkUpdateControllerWhenSelectionsChanged(interactor: FacetListInteractor,
                                                controller: TestFacetListController,
                                                isConnected: Bool) {

    let selectedIndex = 2

    let reloadExpectation = expectation(description: "reload expectation")
    reloadExpectation.isInverted = !isConnected

    controller.didReload = {
      let selections: [Bool] = (0...2).compactMap { i in
        return controller.selectableItems.first { $0.item.value == "f\(i)" }.flatMap { $0.isSelected }
      }

      XCTAssertEqual(selections, (0...2).map { $0 == selectedIndex })

      reloadExpectation.fulfill()
    }

    interactor.selections = [facets[selectedIndex].value]

    waitForExpectations(timeout: 5, handler: .none)

  }

}
