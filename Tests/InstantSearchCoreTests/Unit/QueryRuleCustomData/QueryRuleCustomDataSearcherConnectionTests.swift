//
//  QueryRuleCustomDataSearcherConnectionTests.swift
//
//
//  Created by Vladislav Fitc on 12/10/2020.
//

import Core
import Foundation
import Search
@testable import InstantSearchCore
import XCTest

class QueryRuleCustomDataSearcherConnectionTests: XCTestCase {
  struct TestModel: Codable {
    let number: Int
    let text: String
  }

  func testHitsSearcherConnection() throws {
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let interactor = QueryRuleCustomDataInteractor<TestModel>()

    interactor.connectSearcher(searcher)

    // In v9, userData is AnyCodable - use AnyCodable wrapper
    let response = makeSearchResponse().set(\.userData, to: AnyCodable([["number": 10, "text": "test"]]))

    let itemChangedExpectation = expectation(description: "Item changed")

    interactor.onItemChanged.subscribe(with: self) { _, model in
      XCTAssertEqual(model?.number, 10)
      XCTAssertEqual(model?.text, "test")
      itemChangedExpectation.fulfill()
    }

    searcher.onResults.fire(response)

    waitForExpectations(timeout: 10, handler: nil)
  }

}
