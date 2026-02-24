//
//  DisjuncitveAndHierarchicalIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest
class DisjuncitveAndHierarchicalIntegrationTests: OnlineTestCase {
  struct Item: Codable {
    let name: String
    let color: String?
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

  let colorAttribute = "color"

  let cat1 = "Category1"
  let cat2 = "Category2"
  let cat3 = "Category3"

  let cat2_1 = "Category2 > SubCategory1"
  let cat2_2 = "Category2 > SubCategory2"
  let cat3_1 = "Category3 > SubCategory1"
  let cat3_2 = "Category3 > SubCategory2"

  let cat3_1_1 = "Category3 > SubCategory1 > SubSubCategory1"
  let cat3_1_2 = "Category3 > SubCategory1 > SubSubCategory2"
  let cat3_2_1 = "Category3 > SubCategory2 > SubSubCategory1"
  let cat3_2_2 = "Category3 > SubCategory2 > SubSubCategory2"

  var facetAttributes: [String] {
    return hierarchicalAttributes + [colorAttribute]
  }

  override func setUpWithError() throws {
    try super.setUpWithError()
    let settings = Settings().set(\.attributesForFaceting, to: facetAttributes.map { .default($0) })
    let items: [Item] = try JSONDecoder().decode(fromResource: "disjunctiveHierarchical", withExtension: "json")
    try fillIndex(withItems: items, autoGeneratingObjectID: true, settings: settings)
  }

  func testDisjuncitiveHierarchical() {
    let expectedHierarchicalFacets: [(String, [FacetHits])] = [
      (lvl0, [
        .init(value: cat3, highlighted: cat3, count: 2),
        .init(value: cat2, highlighted: cat2, count: 1)
      ]),
      (lvl1, [
        .init(value: cat3_2, highlighted: cat3_2, count: 2)
      ]),
      (lvl2, [
        .init(value: cat3_2_1, highlighted: cat3_2_1, count: 1),
        .init(value: cat3_2_2, highlighted: cat3_2_2, count: 1)
      ])
    ]

    let expectedDisjunctiveFacets: [(String, [FacetHits])] = [
      (colorAttribute, [
        FacetHits(value: "red", highlighted: "red", count: 2),
        FacetHits(value: "blue", highlighted: "blue", count: 1)
      ])
    ]

    let colorFilter = Filter.Facet(attribute: colorAttribute, stringValue: "red")

    let hierarchicalFilter = Filter.Facet(attribute: lvl1, stringValue: cat3_2)

    let filterGroups: [FilterGroupType] = [
      FilterGroup.And(filters: [hierarchicalFilter], name: "_hierarchical"),
      FilterGroup.Or(filters: [colorFilter], name: "color")
    ]

    let hierarchicalFilters = [
      Filter.Facet(attribute: lvl0, stringValue: cat3),
      Filter.Facet(attribute: lvl1, stringValue: cat3_2)
    ]

    let query = Query("").set(\.facets, to: facetAttributes)

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)

    let queries = queryBuilder.build()

    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)
    XCTAssertEqual(queryBuilder.hierarchicalFacetingQueriesCount, 3)

    let exp = expectation(description: "results")

    let indexQueries = queries.map { IndexedQuery(indexName: self.indexName, query: $0) }

    Task {
      do {
        let response = try await client.search(
          searchMethodParams: SearchMethodParams(queries: indexQueries.asSearchQueries(), strategy: .none)
        )
        let finalResult = try queryBuilder.aggregate(response.results)
        expectedDisjunctiveFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        expectedHierarchicalFacets.forEach { attribute, facets in
          XCTAssertTrue(finalResult.hierarchicalFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)
  }
}
