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
  
  weak var disposableController: TestHitsController<JSON>?
  weak var disposableInteractor: HitsInteractor<JSON>?
  
  func testLeak() {
    let interactor = self.interactor
    let controller = TestHitsController<JSON>()

    disposableController = controller
    disposableInteractor = interactor
    
    let connection = HitsInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableController, "Leaked controller")
  }

  func testConnect() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    let connection = HitsInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()

    let tester = HitsInteractorControllerConnectionTester(interactor: interactor, controller: controller, source: self)
    tester.check(isConnected: true)

  }

  func testConnectMethod() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    interactor.connectController(controller)

    let tester = HitsInteractorControllerConnectionTester(interactor: interactor, controller: controller, source: self)
    tester.check(isConnected: true)

  }

  func testDisconnect() {

    let controller = TestHitsController<JSON>()
    let interactor = self.interactor

    let connection = HitsInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.disconnect()

    let tester = HitsInteractorControllerConnectionTester(interactor: interactor, controller: controller, source: self)
    tester.check(isConnected: false)

  }

}

class HitsInteractorControllerConnectionTester {
  
  let interactor: HitsInteractor<JSON>
  let controller: TestHitsController<JSON>
  let source: XCTestCase
  
  init(interactor: HitsInteractor<JSON>,
       controller: TestHitsController<JSON>,
       source: XCTestCase) {
    self.interactor = interactor
    self.controller = controller
    self.source = source
  }
  
  func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {

    if isConnected {
      XCTAssertTrue(controller.hitsSource === interactor)
    } else {
      XCTAssertNil(controller.hitsSource)
    }

    let requestChangedExpectation = source.expectation(description: "request changed")
    requestChangedExpectation.isInverted = !isConnected

    controller.didScrollToTop = {
      requestChangedExpectation.fulfill()
    }

    interactor.onRequestChanged.fire(())

    let resultsUpdatedExpectation = source.expectation(description: "results updated")
    resultsUpdatedExpectation.isInverted = !isConnected

    controller.didReload = {
      resultsUpdatedExpectation.fulfill()
    }

    interactor.onResultsUpdated.fire(SearchResponse(hits: [TestRecord<Int>]()))
    
    source.waitForExpectations(timeout: 2, handler: .none)
    
  }
  
}
