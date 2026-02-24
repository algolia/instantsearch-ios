//
//  DisjunctiveFacetingIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest
class DisjunctiveFacetingIntegrationTests: OnlineTestCase {
  struct Item: Codable {
    let category: String
    let color: String?
    let promotions: TreeModel<String>?
  }

  let disjunctiveAttributes: [String] = [
    "category",
    "color",
    "promotions"
  ]

  override func setUpWithError() throws {
    try super.setUpWithError()
    let settings = Settings().set(\.attributesForFaceting, to: disjunctiveAttributes.map { .default($0) })
    let items: [Item] = try JSONDecoder().decode(fromResource: "disjunctive", withExtension: "json")
    try fillIndex(withItems: items, autoGeneratingObjectID: true, settings: settings)
  }

  func testDisjunctive() {
    let expectedFacets: [(String, [FacetHits])] = [
      ("category", [
        .init(value: "shirt", highlighted: "shirt", count: 2),
        .init(value: "hat", highlighted: "hat", count: 1)
      ]),
      ("promotions", [
        .init(value: "free return", highlighted: "free return", count: 2),
        .init(value: "coupon", highlighted: "coupon", count: 1),
        .init(value: "on sale", highlighted: "on sale", count: 1)
      ])
    ]

    let expectedDisjucntiveFacets: [(String, [FacetHits])] = [
      ("color", [
        .init(value: "blue", highlighted: "blue", count: 3),
        .init(value: "green", highlighted: "green", count: 2),
        .init(value: "orange", highlighted: "orange", count: 2),
        .init(value: "yellow", highlighted: "yellow", count: 2),
        .init(value: "red", highlighted: "red", count: 1)
      ])
    ]

    let query = Query().set(\.facets, to: disjunctiveAttributes)
    let colorFilter = Filter.Facet(attribute: "color", stringValue: "blue")
    let disjunctiveGroup = FilterGroup.Or(filters: [colorFilter], name: "colors")
    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [disjunctiveGroup])

    let queries = queryBuilder.build().map { IndexedQuery(indexName: indexName, query: $0) }

    XCTAssertEqual(queries.count, 2)
    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)

    let exp = expectation(description: "results")

    Task {
      do {
        let response = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let finalResult = try queryBuilder.aggregate(response.results)
        expectedFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        expectedDisjucntiveFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)
  }

  func testMultiDisjunctive() {
    let expectedFacets: [(String, [FacetHits])] = [
      ("category", [
        .init(value: "shirt", highlighted: "shirt", count: 1)
      ]),
      ("promotions", [
        .init(value: "coupon", highlighted: "coupon", count: 1)
      ])
    ]

    let expectedDisjucntiveFacets: [(String, [FacetHits])] = [
      ("color", [
        .init(value: "blue", highlighted: "blue", count: 1)
      ])
    ]

    let query = Query().set(\.facets, to: disjunctiveAttributes)
    let colorFilter = Filter.Facet(attribute: "color", stringValue: "blue")
    let disjunctiveGroup = FilterGroup.Or(filters: [colorFilter], name: "colors")
    let promotionsFilter = Filter.Facet(attribute: "promotions", stringValue: "coupon")
    let conjunctiveGroup = FilterGroup.And(filters: [promotionsFilter], name: "promotions")
    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [disjunctiveGroup, conjunctiveGroup])

    let queries = queryBuilder.build().map { IndexedQuery(indexName: indexName, query: $0) }

    XCTAssertEqual(queries.count, 2)
    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)

    let exp = expectation(description: "results")

    Task {
      do {
        let response = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let finalResult = try queryBuilder.aggregate(response.results)
        expectedFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        expectedDisjucntiveFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        exp.fulfill()
      } catch {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)
  }
}
