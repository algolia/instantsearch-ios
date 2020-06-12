//
//  QueryInputControllerConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class QueryInputControllerConnectionTests: XCTestCase {

  func testConnect() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()
    let presetQuery = "q1"
    interactor.query = presetQuery

    let connection = QueryInputInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()

    check(interactor: interactor,
          controller: controller,
          presetQuery: presetQuery,
          isConnected: true)

  }

  func testConnectMethod() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()
    let presetQuery = "q1"
    interactor.query = presetQuery

    interactor.connectController(controller)

    check(interactor: interactor,
          controller: controller,
          presetQuery: presetQuery,
          isConnected: true)

  }

  func testDisconnect() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()

    let connection = QueryInputInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()
    connection.disconnect()

    check(interactor: interactor,
          controller: controller,
          presetQuery: nil,
          isConnected: false)

  }

  func check(interactor: QueryInputInteractor,
             controller: TestQueryInputController,
             presetQuery: String?,
             isConnected: Bool) {

    XCTAssertEqual(controller.query, presetQuery)

    controller.query = "q2"

    if isConnected {
      XCTAssertEqual(interactor.query, "q2")
    } else {
      XCTAssertNil(interactor.query)
    }

    controller.query = "q3"

    let querySubmittedExpectation = expectation(description: "query submitted")
    querySubmittedExpectation.isInverted = !isConnected

    interactor.onQuerySubmitted.subscribe(with: self) { _, query in
      XCTAssertEqual(query, "q3")
      querySubmittedExpectation.fulfill()
    }

    controller.submitQuery()

    waitForExpectations(timeout: 2, handler: nil)

  }

}
