//
//  DisjunctiveFacetingIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import Search
@testable import InstantSearchCore
import XCTest
class DisjunctiveFacetingIntegrationTests: OnlineTestCase {
  struct Item: Codable {
    let category: String
    let color: String?
    let promotions: AnyCodable?
  }

  let disjunctiveAttributes: [String] = [
    "category",
    "color",
    "promotions"
  ]

  override func setUpWithError() throws {
    try super.setUpWithError()
    let settings = IndexSettings().set(\.attributesForFaceting, to: disjunctiveAttributes)
    let items: [Item] = try JSONDecoder().decode(fromResource: "disjunctive", withExtension: "json")
    try fillIndex(withItems: items, autoGeneratingObjectID: true, settings: settings)
  }

  func testDisjunctive() {
    let expectedFacets: [(String, [InstantSearchCore.FacetHits])] = [
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

    let expectedDisjucntiveFacets: [(String, [InstantSearchCore.FacetHits])] = [
      ("color", [
        .init(value: "blue", highlighted: "blue", count: 3),
        .init(value: "green", highlighted: "green", count: 2),
        .init(value: "orange", highlighted: "orange", count: 2),
        .init(value: "yellow", highlighted: "yellow", count: 2),
        .init(value: "red", highlighted: "red", count: 1)
      ])
    ]

    let query = SearchSearchParamsObject().set(\.facets, to: disjunctiveAttributes)
    let colorFilter = Filter.Facet(attribute: "color", stringValue: "blue")
    let disjunctiveGroup = FilterGroup.Or(filters: [colorFilter], name: "colors")
    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [disjunctiveGroup])

    let queries = queryBuilder.build().map { IndexedQuery(indexName: indexName, query: $0) }

    XCTAssertEqual(queries.count, 2)
    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)

    let exp = expectation(description: "results")

    Task {
      do {
        let response: SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let responses = response.results.compactMap(\.asSearchResponse)
        let finalResult = try queryBuilder.aggregate(responses)
        expectedFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { InstantSearchCore.FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        expectedDisjucntiveFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { InstantSearchCore.FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
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
    let expectedFacets: [(String, [InstantSearchCore.FacetHits])] = [
      ("category", [
        .init(value: "shirt", highlighted: "shirt", count: 1)
      ]),
      ("promotions", [
        .init(value: "coupon", highlighted: "coupon", count: 1)
      ])
    ]

    let expectedDisjucntiveFacets: [(String, [InstantSearchCore.FacetHits])] = [
      ("color", [
        .init(value: "blue", highlighted: "blue", count: 1)
      ])
    ]

    let query = SearchSearchParamsObject().set(\.facets, to: disjunctiveAttributes)
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
        let response: SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: queries.asSearchQueries(), strategy: .none)
        )
        let responses = response.results.compactMap(\.asSearchResponse)
        let finalResult = try queryBuilder.aggregate(responses)
        expectedFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { InstantSearchCore.FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
          XCTAssertTrue(facetHits.equalContents(to: facets))
        }
        expectedDisjucntiveFacets.forEach { attribute, facets in
          let values = finalResult.facets?[attribute] ?? [:]
          let facetHits = values.map { InstantSearchCore.FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
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
