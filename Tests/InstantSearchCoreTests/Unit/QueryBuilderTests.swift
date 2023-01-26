//
//  QueryBuilderTests.swift
//
//
//  Created by Vladislav Fitc on 16/12/2020.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class QueryBuilderTests: XCTestCase {
  func testDisjunctiveFacetingQueriesGeneration() {
    let query = Query("phone")
    let disjunctiveFacets: Set<Attribute> = ["price", "color"]

    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: disjunctiveFacets)

    let queries = queryBuilder.build()

    XCTAssertNotNil(queries.first)

    let disjunctiveFacetingQueries = Array(queries[1...])
    XCTAssertEqual(disjunctiveFacetingQueries.count, 2)

    disjunctiveFacetingQueries.forEach { XCTAssertEqual($0.facets?.count, 1) }
    let disjunctiveFacetingQueriesFacetSet: Set<Attribute> = disjunctiveFacetingQueries.compactMap { $0.facets ?? [] }.reduce([]) { $0.union($1) }
    XCTAssertEqual(disjunctiveFacets, disjunctiveFacetingQueriesFacetSet)
  }

  func testDisjunctiveFacetingWithFiltersQueriesGeneration() {
    let query = Query("phone")
    let disjunctiveFacets: Set<Attribute> = ["price", "color", "brand"]
    let filterGroups: [FilterGroupType] = [
      FilterGroup.Or(filters: [Filter.Facet(attribute: "price", value: 100), Filter.Facet(attribute: "color", value: "green"), Filter.Facet(attribute: "size", value: "44")], name: "g1"),
      FilterGroup.Or(filters: [Filter.Facet(attribute: "type", value: "phone")], name: "g2"),
      FilterGroup.And(filters: [Filter.Facet(attribute: "color", value: "red"), Filter.Numeric(attribute: "price", range: 20...50), Filter.Tag(value: "On sale")] as [FilterType], name: "g3")
    ]

    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: disjunctiveFacets, filterGroups: filterGroups)

    let queries = queryBuilder.build()

    XCTAssertNotNil(queries.first)

    let disjunctiveFacetingQueries = Array(queries[1...])
    XCTAssertEqual(disjunctiveFacetingQueries.count, 5)

    disjunctiveFacetingQueries.forEach { XCTAssertEqual($0.facets?.count, 1) }

    let priceFilterString = "\"price\":\"100.0\""
    let sizeFilterString = "\"size\":\"44\""
    let colorFilterString = "\"color\":\"green\""
    let singletonOrGroupString = "( \"type\":\"phone\" )"
    let intactAndGroupString = "( \"color\":\"red\" AND \"price\":20.0 TO 50.0 AND \"_tags\":\"On sale\" )"

    for query in disjunctiveFacetingQueries {
      let disjunctiveFacetingAttribute = query.facets!.first!
      switch disjunctiveFacetingAttribute {
      case "price":
        XCTAssertEqual(query.filters, "( \(colorFilterString) OR \(sizeFilterString) ) AND \(singletonOrGroupString) AND \(intactAndGroupString)")
      case "color":
        XCTAssertEqual(query.filters, "( \(priceFilterString) OR \(sizeFilterString) ) AND \(singletonOrGroupString) AND \(intactAndGroupString)")
      case "size":
        XCTAssertEqual(query.filters, "( \(priceFilterString) OR \(colorFilterString) ) AND \(singletonOrGroupString) AND \(intactAndGroupString)")
      case "type":
        XCTAssertEqual(query.filters, "( \(priceFilterString) OR \(colorFilterString) OR \(sizeFilterString) ) AND \(intactAndGroupString)")
      case "brand":
        XCTAssertEqual(query.filters, "( \(priceFilterString) OR \(colorFilterString) OR \(sizeFilterString) ) AND \(singletonOrGroupString) AND \(intactAndGroupString)")
      case let unexpectedAttribute:
        XCTFail("Unexpected disjunctive faceting attribute \"\(unexpectedAttribute)\" ")
      }
    }
  }
}
