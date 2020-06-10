//
//  CurrentFiltersControllerConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class CurrentFiltersControllerConnectionTests: XCTestCase {

  let attribute: Attribute = "Test Attribute"
  let groupName = "Test group"

  func testConnect() {

    let interactor = CurrentFiltersInteractor()
    let controller = TestCurrentFiltersController()

    let connection = CurrentFiltersInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)
  }

  func testConnectFunction() {

    let interactor = CurrentFiltersInteractor()
    let controller = TestCurrentFiltersController()

    interactor.connectController(controller)

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)

  }

  func testDisconnect() {
    let interactor = CurrentFiltersInteractor()
    let controller = TestCurrentFiltersController()

    let connection = CurrentFiltersInteractor.ControllerConnection(interactor: interactor,
                                                                   controller: controller)
    connection.connect()
    connection.disconnect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: false)
  }

  func checkConnection(interactor: CurrentFiltersInteractor,
                       controller: TestCurrentFiltersController,
                       isConnected: Bool) {
    checkUpdateControllerWhenItemsChanged(interactor: interactor,
                                          controller: controller,
                                          isConnected: isConnected)
    checkItemsComputedOnRemove(interactor: interactor,
                               controller: controller,
                               isConnected: isConnected)
  }

  func checkItemsComputedOnRemove(interactor: CurrentFiltersInteractor,
                                  controller: TestCurrentFiltersController,
                                  isConnected: Bool) {

    let item = FilterAndID(filter: .tag("tag"), id: .and(name: groupName))

    interactor.items = Set([item])

    let selectionsComputedExpectation = expectation(description: "selections computed")
    selectionsComputedExpectation.isInverted = !isConnected

    interactor.onItemsComputed.subscribe(with: self) { (_, items) in
      XCTAssertTrue(items.isEmpty)
      selectionsComputedExpectation.fulfill()
    }

    controller.onRemoveItem?(item)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func checkUpdateControllerWhenItemsChanged(interactor: CurrentFiltersInteractor,
                                             controller: TestCurrentFiltersController,
                                             isConnected: Bool) {

    let reloadExpectation = expectation(description: "reload expectation")
    reloadExpectation.isInverted = !isConnected

    let expectedItems = [FilterAndID(filter: .tag("tag"), id: .and(name: groupName), text: "tag")]

    controller.didReload = {
      XCTAssertEqual(controller.items, expectedItems)
      reloadExpectation.fulfill()
    }

    interactor.items = Set(expectedItems)

    waitForExpectations(timeout: 5, handler: nil)

  }

}
