//
//  QueryInputInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class QueryInputInteractorTests: XCTestCase {

  func testOnQueryChangedEvent() {

    let interactor = QueryInputInteractor()

    let onQueryChangedExpectation = expectation(description: "on query changed")

    let changedQuery = "q1"

    interactor.onQueryChanged.subscribe(with: self) { _, query in
      XCTAssertEqual(query, changedQuery)
      onQueryChangedExpectation.fulfill()
    }

    interactor.query = changedQuery

    waitForExpectations(timeout: 2, handler: nil)

  }

  func testOnQuerySubmittedEvent() {

    let interactor = QueryInputInteractor()
    let onQuerySubmittedExpectation = expectation(description: "on query submitted")
    let submittedQuery = "q2"

    interactor.onQuerySubmitted.subscribe(with: self) { _, query in
      XCTAssertEqual(submittedQuery, query)
      onQuerySubmittedExpectation.fulfill()
    }

    interactor.query = submittedQuery
    interactor.submitQuery()

    waitForExpectations(timeout: 2, handler: nil)

  }

  func testSearcherQuerySet() {
    let searcher = TestSearcher()
    let interactor = QueryInputInteractor()
    let query = "q1"
    searcher.query = query
    interactor.connectSearcher(searcher, searchTriggeringMode: .searchOnSubmit)
    XCTAssertEqual(interactor.query, query)
  }

}
