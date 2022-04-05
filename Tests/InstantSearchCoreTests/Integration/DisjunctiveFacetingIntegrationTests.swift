//
//  DisjunctiveFacetingIntegrationTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore
import AlgoliaSearchClient
class DisjunctiveFacetingIntegrationTests: OnlineTestCase {

  struct Item: Codable {
    let objectID: String = UUID().uuidString
    let category: String
    let color: String?
    let promotions: TreeModel<String>?
  }

  let disjunctiveAttributes: [Attribute] = [
    "category",
    "color",
    "promotions"
  ]

  override func setUpWithError() throws {
    try super.setUpWithError()
    let settings = Settings().set(\.attributesForFaceting, to: disjunctiveAttributes.map { .default($0) })
    let items: [Item] = try JSONDecoder().decode(fromResource: "disjunctive", withExtension: "json")
    try fillIndex(withItems: items, settings: settings)
  }

  func testDisjunctive() {

    let expectedFacets: [(Attribute, [Facet])] = [
      ("category", [
        .init(value: "shirt", count: 2, highlighted: nil),
        .init(value: "hat", count: 1, highlighted: nil)
        ]),
      ("promotions", [
        .init(value: "free return", count: 2, highlighted: nil),
        .init(value: "coupon", count: 1, highlighted: nil),
        .init(value: "on sale", count: 1, highlighted: nil)
      ])
    ]

    let expectedDisjucntiveFacets: [(Attribute, [Facet])] = [
      ("color", [
        .init(value: "blue", count: 3, highlighted: nil),
        .init(value: "green", count: 2, highlighted: nil),
        .init(value: "orange", count: 2, highlighted: nil),
        .init(value: "yellow", count: 2, highlighted: nil),
        .init(value: "red", count: 1, highlighted: nil)
      ])
    ]

    let query = Query().set(\.facets, to: Set(disjunctiveAttributes))
    let colorFilter = Filter.Facet(attribute: "color", stringValue: "blue")
    let disjunctiveGroup = FilterGroup.Or(filters: [colorFilter], name: "colors")
    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [disjunctiveGroup])

    let queries = queryBuilder.build().map { IndexedQuery(indexName: index.name, query: $0) }

    XCTAssertEqual(queries.count, 2)
    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)

    let exp = expectation(description: "results")

    client.multipleQueries(queries: queries) { result in
      do {
        let searchesResponse = try result.get()
        let finalResult = try! queryBuilder.aggregate(searchesResponse.results)
        expectedFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.facets?[attribute]?.equalContents(to: facets) == true)
        }
        expectedDisjucntiveFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.disjunctiveFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()

      } catch let error {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)

  }

  func testMultiDisjunctive() {

    let expectedFacets: [(Attribute, [Facet])] = [
      ("category", [
        .init(value: "shirt", count: 1, highlighted: nil)
        ]),
      ("promotions", [
        .init(value: "coupon", count: 1, highlighted: nil)
        ])
    ]

    let expectedDisjucntiveFacets: [(Attribute, [Facet])] = [
      ("color", [
        .init(value: "blue", count: 1, highlighted: nil)
        ])
    ]

    let query = Query().set(\.facets, to: Set(disjunctiveAttributes))
    let colorFilter = Filter.Facet(attribute: "color", stringValue: "blue")
    let disjunctiveGroup = FilterGroup.Or(filters: [colorFilter], name: "colors")
    let promotionsFilter = Filter.Facet(attribute: "promotions", stringValue: "coupon")
    let conjunctiveGroup = FilterGroup.And(filters: [promotionsFilter], name: "promotions")
    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [disjunctiveGroup, conjunctiveGroup])

    let queries = queryBuilder.build().map { IndexedQuery(indexName: index.name, query: $0) }

    XCTAssertEqual(queries.count, 2)
    XCTAssertEqual(queryBuilder.disjunctiveFacetingQueriesCount, 1)

    let exp = expectation(description: "results")

    client.multipleQueries(queries: queries) { result in
      do {
        let searchesResponse = try result.get()
        let finalResult = try queryBuilder.aggregate(searchesResponse.results)
        expectedFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.facets?[attribute]?.equalContents(to: facets) == true)
        }
        expectedDisjucntiveFacets.forEach { (attribute, facets) in
          XCTAssertTrue(finalResult.disjunctiveFacets?[attribute]?.equalContents(to: facets) == true)
        }
        exp.fulfill()
      } catch let error {
        XCTFail("\(error)")
      }
    }

    waitForExpectations(timeout: 15, handler: .none)

  }

}
