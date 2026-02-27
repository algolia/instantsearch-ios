//
//  HitsInteractorRelatedItemsTests.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

import Foundation
@testable import InstantSearchCore
import XCTest

class HitsInteractorRelatedItemsTests: XCTestCase {
  struct Product: Codable {
    let name: String
    let brand: String
    let type: String
    let categories: [String]
    let image: URL
  }

  func testConnect() {
    let matchingPatterns: [MatchingPattern<Product>] =
      [
        MatchingPattern(attribute: "brand", score: 3, filterPath: \.brand),
        MatchingPattern(attribute: "type", score: 10, filterPath: \.type),
        MatchingPattern(attribute: "categories", score: 2, filterPath: \.categories)
      ]

    let searcher = HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "")
    let product = Product(name: "productName", brand: "Amazon", type: "Streaming media plyr", categories: ["Streaming Media Players", "TV & Home Theater"], image: URL(string: "http://url.com")!)

    let hitsInteractor = HitsInteractor<JSON>.init()

    let hit: ObjectWrapper<Product> = .init(object: product, objectID: "objectID123")
    hitsInteractor.connectSearcher(searcher, withRelatedItemsTo: hit, with: matchingPatterns)

    let expectedOptionalFilters: Set<String> = [
      "brand:Amazon<score=3>",
      "categories:Streaming Media Players<score=2>",
      "categories:TV & Home Theater<score=2>",
      "type:Streaming media plyr<score=10>"
    ]
    let expectedFilters = FilterGroupConverter().sql([
      FilterGroup.And(filters: [Filter.Facet(attribute: "objectID", stringValue: "objectID123", isNegated: true)])
    ])

    XCTAssertEqual(searcher.request.query.sumOrFiltersScores, true)
    if case let .arrayOfSearchOptionalFilters(filters) = searcher.request.query.optionalFilters {
      let actual = Set(filters.compactMap { filter -> String? in
        if case let .string(value) = filter { return value }
        return nil
      })
      XCTAssertEqual(actual, expectedOptionalFilters)
    } else {
      XCTFail("Expected arrayOfSearchOptionalFilters")
    }
    XCTAssertEqual(searcher.request.query.filters, expectedFilters)
  }
}
