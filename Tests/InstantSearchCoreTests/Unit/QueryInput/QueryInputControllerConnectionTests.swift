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
  
  weak var disposableInteractor: QueryInputInteractor?
  weak var disposableController: TestQueryInputController?
  
  func testLeak() {
    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()
    
    disposableController = controller
    disposableInteractor = interactor
    
    let connection = QueryInputInteractor.ControllerConnection(interactor: interactor, controller: controller)
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableInteractor, "Leaked interactor")
    XCTAssertNil(disposableInteractor, "Leaked controller")
  }

  func testConnect() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()
    let presetQuery = "q1"
    interactor.query = presetQuery

    let connection = QueryInputInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()

    let tester = QueryInputControllerConnectionTester(interactor: interactor,
                                                      controller: controller,
                                                      presetQuery: presetQuery,
                                                      source: self)
    tester.check(isConnected: true)

  }

  func testConnectMethod() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()
    let presetQuery = "q1"
    interactor.query = presetQuery

    interactor.connectController(controller)

    let tester = QueryInputControllerConnectionTester(interactor: interactor,
                                                      controller: controller,
                                                      presetQuery: presetQuery,
                                                      source: self)
    tester.check(isConnected: true)

  }

  func testDisconnect() {

    let controller = TestQueryInputController()
    let interactor = QueryInputInteractor()

    let connection = QueryInputInteractor.ControllerConnection(interactor: interactor, controller: controller)

    connection.connect()
    connection.disconnect()

    let tester = QueryInputControllerConnectionTester(interactor: interactor,
                                                      controller: controller,
                                                      presetQuery: nil,
                                                      source: self)
    tester.check(isConnected: false)

  }

}

class QueryInputControllerConnectionTester {
  
  let interactor: QueryInputInteractor
  let controller: TestQueryInputController
  let presetQuery: String?
  let source: XCTestCase
  
  init(interactor: QueryInputInteractor,
       controller: TestQueryInputController,
       presetQuery: String?,
       source: XCTestCase) {
    self.interactor = interactor
    self.controller = controller
    self.presetQuery = presetQuery
    self.source = source
  }
  
  func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {

    XCTAssertEqual(controller.query, presetQuery, file: file, line: line)

    controller.query = "q2"

    if isConnected {
      XCTAssertEqual(interactor.query, "q2", file: file, line: line)
    } else {
      XCTAssertNil(interactor.query, file: file, line: line)
    }

    controller.query = "q3"

    let querySubmittedExpectation = source.expectation(description: "query submitted")
    querySubmittedExpectation.isInverted = !isConnected

    interactor.onQuerySubmitted.subscribe(with: self) { _, query in
      XCTAssertEqual(query, "q3", file: file, line: line)
      querySubmittedExpectation.fulfill()
    }

    controller.submitQuery()

    source.waitForExpectations(timeout: 2, handler: nil)

  }

}
