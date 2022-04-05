//
//  HierarchicalIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore
import AlgoliaSearchClient
class HierarchicalTests: OnlineTestCase {

  struct Item: Codable {
    let objectID: String = UUID().uuidString
    let name: String
    let hierarchicalCategories: [String: String]
  }

  static func attribute(for level: Int) -> Attribute {
    return .init(rawValue: "hierarchicalCategories.lvl\(level)")
  }

  let lvl0 = { attribute(for: 0) }()
  let lvl1 = { attribute(for: 1) }()
  let lvl2 = { attribute(for: 2) }()
  var hierarchicalAttributes: [Attribute] {
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
    let settings = Settings().set(\.attributesForFaceting, to: hierarchicalAttributes.map { .default($0) })
    let items: [Item] = try JSONDecoder().decode(fromResource: "hierarchical", withExtension: "json")
    try fillIndex(withItems: items, settings: settings)
  }

  func testHierachical() {

    let filter = Filter.Facet(attribute: lvl1, stringValue: clothing_men)

    let filterGroups = [FilterGroup.And(filters: [filter], name: "_hierarchical")]

    let hierarchicalFilters = [
      Filter.Facet(attribute: lvl0, stringValue: clothing),
      Filter.Facet(attribute: lvl1, stringValue: clothing_men)
    ]

    let expectedHierarchicalFacets: [(Attribute, [Facet])] = [
      (lvl0, [
        .init(value: clothing, count: 4, highlighted: nil),
        .init(value: book, count: 2, highlighted: nil),
        .init(value: furniture, count: 1, highlighted: nil)
        ]),
      (lvl1, [
        .init(value: clothing_men, count: 2, highlighted: nil),
        .init(value: clothing_women, count: 2, highlighted: nil)
        ]),
      (lvl2, [
        .init(value: clothing_men_hats, count: 1, highlighted: nil),
        .init(value: clothing_men_shirt, count: 1, highlighted: nil)
        ])
    ]

    let query = Query("").set(\.facets, to: Set(hierarchicalAttributes))

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.index.name, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 3)

    let exp = expectation(description: "results")

    client.multipleQueries(queries: queries) { result in
      do {
        let searchesResponse = try result.get()
        let finalResult = try queryBuilder.aggregate(searchesResponse.results)
        expectedHierarchicalFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.hierarchicalFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch let error {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)

  }

  func testHierachicalEmpty() throws {

    let filterGroups: [FilterGroupType] = []

    let hierarchicalFilters: [Filter.Facet] = []

    let query = Query("").set(\.facets, to: Set(hierarchicalAttributes))

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.index.name, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 0)

    let exp = expectation(description: "results")

    client!.multipleQueries(queries: queries) { result in
      do {
        let searchesResponse = try result.get()
        let finalResult = try queryBuilder.aggregate(searchesResponse.results)
        XCTAssertNil(finalResult.hierarchicalFacets)
        exp.fulfill()
      } catch let error {
        XCTFail("\(error)")
      }

    }

    waitForExpectations(timeout: 15, handler: .none)

  }

  func testHierarchicalLastLevel() {

    let filter = Filter.Facet(attribute: lvl2, stringValue: clothing_men_hats)

    let filterGroups = [FilterGroup.And(filters: [filter], name: "_hierarchical")]

    let hierarchicalFilters = [
      Filter.Facet(attribute: lvl0, stringValue: clothing),
      Filter.Facet(attribute: lvl1, stringValue: clothing_men),
      Filter.Facet(attribute: lvl2, stringValue: clothing_men_hats)
    ]

    let expectedHierarchicalFacets: [(Attribute, [Facet])] = [
      (lvl0, [
        .init(value: clothing, count: 4, highlighted: nil),
        .init(value: book, count: 2, highlighted: nil),
        .init(value: furniture, count: 1, highlighted: nil)
        ]),
      (lvl1, [
        .init(value: clothing_men, count: 2, highlighted: nil),
        .init(value: clothing_women, count: 2, highlighted: nil)
        ]),
      (lvl2, [
        .init(value: clothing_men_hats, count: 1, highlighted: nil),
        .init(value: clothing_men_shirt, count: 1, highlighted: nil)
        ])
    ]

    let query = Query("").set(\.facets, to: Set(hierarchicalAttributes))

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)
    let queries = queryBuilder.build().map { IndexedQuery(indexName: self.index.name, query: $0) }

    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 3)

    let exp = expectation(description: "results")

    client!.multipleQueries(queries: queries) { result in
      do {
        let searchesResponse = try result.get()
        let finalResult = try queryBuilder.aggregate(searchesResponse.results)
        expectedHierarchicalFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.hierarchicalFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch let error {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)

  }

}

extension Array where Element: Equatable {
  func equalContents(to other: [Element]) -> Bool {
    guard self.count == other.count else { return false }
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
