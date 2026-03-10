//
//  HierarchicalIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearch
@testable import InstantSearchCore
import XCTest
class HierarchicalTests: OnlineTestCase {
  struct Item: Codable {
    let name: String
    let hierarchicalCategories: [String: String]
  }

  static func attribute(for level: Int) -> String {
    return "hierarchicalCategories.lvl\(level)"
  }

  let lvl0 = attribute(for: 0)
  let lvl1 = attribute(for: 1)
  let lvl2 = attribute(for: 2)
  var hierarchicalAttributes: [String] {
    return [lvl0, lvl1, lvl2]
  }

  let clothing = "Clothing"
  let book = "Book"
  let furniture = "Furniture"

  let clothing_men = "Clothing > Men"
  let clothing_women = "Clothing > Women"

  let clothing_men_hats = "Clothing > Men > Hats"
  let clothing_men_shirt = "Clothing > Men > Shirt"

  override func setUpWithError() throws {
    try super.setUpWithError()
    let settings = IndexSettings().set(\.attributesForFaceting, to: hierarchicalAttributes)
    let items: [Item] = try JSONDecoder().decode(fromResource: "hierarchical", withExtension: "json")
    try fillIndex(withItems: items, autoGeneratingObjectID: true, settings: settings)
  }

  func testHierachical() {
    let filter = Filter.Facet(attribute: lvl1, stringValue: clothing_men)

    let filterGroups = [FilterGroup.And(filters: [filter], name: "_hierarchical")]

    let hierarchicalFilters = [
      Filter.Facet(attribute: lvl0, stringValue: clothing),
      Filter.Facet(attribute: lvl1, stringValue: clothing_men)
    ]

    let expectedHierarchicalFacets: [(String, [InstantSearchCore.FacetHits])] = [
      (lvl0, [
        .init(value: clothing, highlighted: clothing, count: 4),
        .init(value: book, highlighted: book, count: 2),
        .init(value: furniture, highlighted: furniture, count: 1)
      ]),
      (lvl1, [
        .init(value: clothing_men, highlighted: clothing_men, count: 2),
        .init(value: clothing_women, highlighted: clothing_women, count: 2)
      ]),
      (lvl2, [
        .init(value: clothing_men_hats, highlighted: clothing_men_hats, count: 1),
        .init(value: clothing_men_shirt, highlighted: clothing_men_shirt, count: 1)
      ])
    ]

    let query = SearchSearchParamsObject(query: "").set(\.facets, to: hierarchicalAttributes)

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.indexName, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 3)

    let exp = expectation(description: "results")

    Task {
      do {
        let searchesResponse: SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let responses = searchesResponse.results.compactMap(\.asSearchResponse)
        let finalResult = try queryBuilder.aggregate(responses)
        expectedHierarchicalFacets.forEach { attribute, facets in
          XCTAssertTrue(finalResult.hierarchicalFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: expectationTimeout, handler: .none)
  }

  func testHierachicalEmpty() throws {
    let filterGroups: [FilterGroupType] = []

    let hierarchicalFilters: [Filter.Facet] = []

    let query = SearchSearchParamsObject(query: "").set(\.facets, to: hierarchicalAttributes)

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.indexName, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 0)

    let exp = expectation(description: "results")

    Task {
      do {
        let searchesResponse: SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let responses = searchesResponse.results.compactMap(\.asSearchResponse)
        let finalResult = try queryBuilder.aggregate(responses)
        XCTAssertNotNil(finalResult.hierarchicalFacets)
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: expectationTimeout, handler: .none)
  }

  func testHierarchicalLastLevel() {
    let filter = Filter.Facet(attribute: lvl2, stringValue: clothing_men_hats)

    let filterGroups = [FilterGroup.And(filters: [filter], name: "_hierarchical")]

    let hierarchicalFilters = [
      Filter.Facet(attribute: lvl0, stringValue: clothing),
      Filter.Facet(attribute: lvl1, stringValue: clothing_men),
      Filter.Facet(attribute: lvl2, stringValue: clothing_men_hats)
    ]

    let expectedHierarchicalFacets: [(String, [InstantSearchCore.FacetHits])] = [
      (lvl0, [
        .init(value: clothing, highlighted: clothing, count: 4),
        .init(value: book, highlighted: book, count: 2),
        .init(value: furniture, highlighted: furniture, count: 1)
      ]),
      (lvl1, [
        .init(value: clothing_men, highlighted: clothing_men, count: 2),
        .init(value: clothing_women, highlighted: clothing_women, count: 2)
      ]),
      (lvl2, [
        .init(value: clothing_men_hats, highlighted: clothing_men_hats, count: 1),
        .init(value: clothing_men_shirt, highlighted: clothing_men_shirt, count: 1)
      ])
    ]

    let query = SearchSearchParamsObject(query: "").set(\.facets, to: hierarchicalAttributes)

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.indexName, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 3)

    let exp = expectation(description: "results")

    Task {
      do {
        let searchesResponse: SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let responses = searchesResponse.results.compactMap(\.asSearchResponse)
        let finalResult = try queryBuilder.aggregate(responses)
        expectedHierarchicalFacets.forEach { attribute, facets in
          XCTAssertTrue(finalResult.hierarchicalFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: expectationTimeout, handler: .none)
  }
}

extension Array where Element: Equatable {
  func equalContents(to other: [Element]) -> Bool {
    guard count == other.count else { return false }
    for e in self {
      let currentECount = filter { $0 == e }.count
      let otherECount = other.filter { $0 == e }.count
      guard currentECount == otherECount else {
        return false
      }
    }
    return true
  }
}
