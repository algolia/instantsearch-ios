//
//  HitsInteractorRelatedItemsTests.swift
//  InstantSearchCore
//
//  Created by test test on 23/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import InstantSearchCore

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
        MatchingPattern(attribute: "categories", score: 2, filterPath: \.categories),
      ]

    let searcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
    let product = Product(name: "productName", brand: "Amazon", type: "Streaming media plyr", categories: ["Streaming Media Players", "TV & Home Theater"], image: URL.init(string: "http://url.com")!)
    
    let hitsInteractor = HitsInteractor<JSON>.init()
    
    let hit: ObjectWrapper<Product> = .init(objectID: "objectID123", object: product)
    hitsInteractor.connectSearcher(searcher, withRelatedItemsTo: hit, with: matchingPatterns)
    
    let expectedOptionalFilter: FiltersStorage = [
      .and("brand:Amazon<score=3>"),
      .or("categories:Streaming Media Players<score=2>", "categories:TV & Home Theater<score=2>"),
      .and("type:Streaming media plyr<score=10>")]
    
    XCTAssertEqual(searcher.indexQueryState.query.sumOrFiltersScores, true)
    XCTAssertEqual(searcher.indexQueryState.query.optionalFilters?.units, expectedOptionalFilter.units)
    XCTAssertEqual(searcher.indexQueryState.query.facetFilters?.units, (["objectID:-objectID123"] as FiltersStorage).units)
    
  }
}
