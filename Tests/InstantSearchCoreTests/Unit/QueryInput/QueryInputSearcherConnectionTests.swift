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

  func testSearchAsYouTypeConnect() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    check(connect: true, interactor: interactor, searcher: searcher, mode: .searchAsYouType)
  }

  func testSearchAsYouTypeConnectMethod() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    interactor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    checkConnection(interactor: interactor,
                    searcher: searcher,
                    triggeringMode: .searchAsYouType,
                    isConnected: true)
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
    checkConnection(interactor: interactor,
                    searcher: searcher,
                    triggeringMode: .searchOnSubmit,
                    isConnected: true)
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

    if connect {
      checkConnection(interactor: interactor,
                      searcher: searcher,
                      triggeringMode: mode,
                      isConnected: true)
    } else {
      connection.disconnect()

      checkConnection(interactor: interactor,
                      searcher: searcher,
                      triggeringMode: mode,
                      isConnected: false)
    }

  }

  func checkConnection(interactor: QueryInputInteractor,
                       searcher: TestSearcher,
                       triggeringMode: SearchTriggeringMode,
                       isConnected: Bool) {

    let query = "q1"

    let launchSearchExpectation = expectation(description: "search launched search")
    launchSearchExpectation.isInverted = !isConnected

    let queryChangedExpectation = expectation(description: "query changed expectation")

    let querySubmittedExpectation = expectation(description: "query submitted expectation")
    querySubmittedExpectation.isInverted = triggeringMode != .searchOnSubmit

    interactor.onQuerySubmitted.subscribe(with: self) { _, _ in
      querySubmittedExpectation.fulfill()
    }

    interactor.onQueryChanged.subscribe(with: self) { (_, _) in
      queryChangedExpectation.fulfill()
    }

    searcher.didLaunchSearch = {
      XCTAssertEqual(searcher.query, query)
      launchSearchExpectation.fulfill()
    }

    interactor.query = query

    if triggeringMode == .searchOnSubmit {
      interactor.submitQuery()
    }

    waitForExpectations(timeout: 5, handler: nil)

  }

}
