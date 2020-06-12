//
//  HitsInteractorControllerConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class HitsInteractorControllerConnectionTests: XCTestCase {

  var interactor: HitsInteractor<JSON> {
    return HitsInteractor<JSON>(settings: .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
          paginationController: .init(),
    infiniteScrollingController: TestInfiniteScrollingController())
  }

  func testConnect() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    let connection = HitsInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)

  }

  func testConnectMethod() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    interactor.connectController(controller)

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: true)

  }

  func testDisconnect() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    let connection = HitsInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.disconnect()

    checkConnection(interactor: interactor,
                    controller: controller,
                    isConnected: false)

  }

  func checkConnection(interactor: HitsInteractor<JSON>,
                       controller: TestHitsController<JSON>,
                       isConnected: Bool) {

    if isConnected {
      XCTAssertTrue(controller.hitsSource === interactor)
    } else {
      XCTAssertNil(controller.hitsSource)
    }

    let requestChangedExpectation = expectation(description: "request changed")
    requestChangedExpectation.isInverted = !isConnected

    controller.didScrollToTop = {
      requestChangedExpectation.fulfill()
    }

    interactor.onRequestChanged.fire(())

    let resultsUpdatedExpectation = expectation(description: "results updated")
    resultsUpdatedExpectation.isInverted = !isConnected

    controller.didReload = {
      resultsUpdatedExpectation.fulfill()
    }

    interactor.onResultsUpdated.fire(SearchResponse(hits: [TestRecord<Int>]()))

    waitForExpectations(timeout: 5, handler: .none)
  }

}
