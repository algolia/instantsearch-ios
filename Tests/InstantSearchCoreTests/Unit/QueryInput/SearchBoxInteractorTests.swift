//
//  SearchBoxInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class SearchBoxInteractorTests: XCTestCase {

  func testOnQueryChangedEvent() {

    let interactor = SearchBoxInteractor()

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

    let interactor = SearchBoxInteractor()
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

}
