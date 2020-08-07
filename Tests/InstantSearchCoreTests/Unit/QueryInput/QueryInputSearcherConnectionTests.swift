//
//  QueryInputSearcherConnectionTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class QueryInputSearcherConnectionTests: XCTestCase {
  
  weak var disposableSearcher: TestSearcher?
  weak var disposableInteractor: QueryInputInteractor?
  
  func testLeak() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    let connection = QueryInputInteractor.SearcherConnection(interactor: interactor, searcher: searcher, searchTriggeringMode: .searchAsYouType)
    connection.connect()
  }
  
  override func tearDown() {
    XCTAssertNil(disposableSearcher, "Leaked searcher")
    XCTAssertNil(disposableInteractor, "Leaked interactor")
  }
  
  func testSearchAsYouTypeConnect() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    check(connect: true, interactor: interactor, searcher: searcher, mode: .searchAsYouType)
  }

  func testSearchAsYouTypeConnectMethod() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    interactor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    let tester = QueryInputSearcherConnectionTester(interactor: interactor,
                                                    searcher: searcher,
                                                    triggeringMode: .searchAsYouType,
                                                    source: self)
    tester.check(isConnected: true)
  }

  func testSearchAsYouTypeDisconnect() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    check(connect: false, interactor: interactor, searcher: searcher, mode: .searchAsYouType)
  }

  func testSearchOnSubmitConnect() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    check(connect: true, interactor: interactor, searcher: searcher, mode: .searchOnSubmit)
  }

  func testSearchOnSubmitConnectMethod() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    interactor.connectSearcher(searcher, searchTriggeringMode: .searchOnSubmit)
    let tester = QueryInputSearcherConnectionTester(interactor: interactor,
                                                    searcher: searcher,
                                                    triggeringMode: .searchOnSubmit,
                                                    source: self)
    tester.check(isConnected: true)
  }

  func testSearchOnSubmitDisconnect() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    check(connect: false, interactor: interactor, searcher: searcher, mode: .searchOnSubmit)
  }

  func check(connect: Bool,
             interactor: QueryInputInteractor,
             searcher: TestSearcher,
             mode: SearchTriggeringMode) {
    let connection = QueryInputInteractor.SearcherConnection(interactor: interactor, searcher: searcher, searchTriggeringMode: mode)
    connection.connect()

    let tester = QueryInputSearcherConnectionTester(interactor: interactor,
                                                    searcher: searcher,
                                                    triggeringMode: mode,
                                                    source: self)
    
    if connect {
      tester.check(isConnected: true)
    } else {
      connection.disconnect()
      tester.check(isConnected: false)
    }

  }

}

class QueryInputSearcherConnectionTester {
  
  let interactor: QueryInputInteractor
  let searcher: TestSearcher
  let triggeringMode: SearchTriggeringMode
  let source: XCTestCase
  
  init(interactor: QueryInputInteractor,
       searcher: TestSearcher,
       triggeringMode: SearchTriggeringMode,
       source: XCTestCase) {
    self.interactor = interactor
    self.searcher = searcher
    self.triggeringMode = triggeringMode
    self.source = source
  }
  
  func check(isConnected: Bool, file: StaticString = #file, line: UInt = #line) {

    let query = "q1"

    let launchSearchExpectation = source.expectation(description: "search launched search")
    launchSearchExpectation.isInverted = !isConnected

    let queryChangedExpectation = source.expectation(description: "query changed expectation")

    let querySubmittedExpectation = source.expectation(description: "query submitted expectation")
    querySubmittedExpectation.isInverted = triggeringMode != .searchOnSubmit

    interactor.onQuerySubmitted.subscribe(with: self) { _, _ in
      querySubmittedExpectation.fulfill()
    }

    interactor.onQueryChanged.subscribe(with: self) { (_, _) in
      queryChangedExpectation.fulfill()
    }
    
    searcher.onSearch.subscribe(with: self) { test, _ in
      XCTAssertEqual(test.searcher.query, query)
      launchSearchExpectation.fulfill()
    }

    interactor.query = query

    if triggeringMode == .searchOnSubmit {
      interactor.submitQuery()
    }

    source.waitForExpectations(timeout: 5, handler: nil)

  }

  
}
