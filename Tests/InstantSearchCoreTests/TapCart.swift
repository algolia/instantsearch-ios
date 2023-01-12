//
//  File.swift
//  
//
//  Created by Vladislav Fitc on 11/01/2023.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class TapCart: XCTestCase {
  
  func testExample() {
    
    let exp = expectation(description: "call")
    
let client = SearchClient(appID: "appID", apiKey: "apiKey")
let searchService = AlgoliaSearchService(client: client)
let filterState = FilterState()
searchService.disjunctiveFacetingDelegate = filterState

filterState[or: "staticOrFilters"].addAll([
  Filter.Facet(attribute: "inStock", value: true),
  Filter.Facet(attribute: "isForcedSoldOut", value: 1),
  Filter.Facet(attribute: "isStayInCollection", value: 1),
])

filterState[and: "staticAndFilters"].add(Filter.Facet(attribute: "isPublishedInApp", value: true))
filterState[or: "colors"].addAll([Filter.Facet(attribute: "color", value: "black"), Filter.Facet(attribute: "color", value: "beige")])

let query = Query()

searchService.search(.init(indexName: "indexName", query: query)) { result in
  switch result {
  case .failure(let error):
    print(error)
    
  case .success(let response):
    print(response)
  }
}
    
    waitForExpectations(timeout: 10)
    
  }
  
  
}
