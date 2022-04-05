//
//  DisjunctiveFacetingsTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore
import AlgoliaSearchClient

class DisjunctiveFacetingTests: XCTestCase {
  
  func testMergeResults() throws {

    let query = Query()

    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: [
      FilterGroup.Or(filters: [Filter.Facet(attribute: "price", floatValue: 100)], name: "price"),
      FilterGroup.Or(filters: [Filter.Facet(attribute: "pubYear", floatValue: 2000)], name: "pubYear")
    ])
    
    let res1: SearchResponse = try JSONDecoder().decode(fromResource: "DisjFacetingResult1", withExtension: "json")
    let res2: SearchResponse = try JSONDecoder().decode(fromResource: "DisjFacetingResult2", withExtension: "json")
    let res3: SearchResponse = try JSONDecoder().decode(fromResource: "DisjFacetingResult3", withExtension: "json")

    do {
      let output = try queryBuilder.aggregate([res1, res2, res3])
      XCTAssertEqual(output.facetStats?.count, 2)
      XCTAssertEqual(output.disjunctiveFacets?.count, 2)
      XCTAssertEqual(output.disjunctiveFacets?.map { $0.key }.contains("price"), true)
      XCTAssertEqual(output.disjunctiveFacets?.map { $0.key }.contains("pubYear"), true)
    } catch let error {
      XCTFail("\(error)")
    }

  }

  func testMultipleDisjunctiveGroupsOfSameType() {

    let query = Query()

    let colorGroup = FilterGroup.Or<Filter.Facet>(filters: [.init(attribute: "color", stringValue: "red"), .init(attribute: "color", stringValue: "green")], name: "color")
    let sizeGroup = FilterGroup.Or<Filter.Facet>(filters: [.init(attribute: "size", stringValue: "m"), .init(attribute: "size", stringValue: "s")], name: "size")

    let filterGroups: [FilterGroupType] = [colorGroup, sizeGroup]

    let queryBuilder = QueryBuilder(query: query, disjunctiveFacets: [], filterGroups: filterGroups)

    let queries = queryBuilder.build()

    let andQuery = queries.first!
    XCTAssertNil(andQuery.facets)
    XCTAssertEqual(andQuery.filters, """
    ( "color":"red" OR "color":"green" ) AND ( "size":"m" OR "size":"s" )
    """)

    for query in queries[1...] {
      switch query.facets {
      case ["size"]:
        XCTAssertEqual(query.filters, """
        ( "color":"red" OR "color":"green" )
        """)

      case ["color"]:
        XCTAssertEqual(query.filters, """
        ( "size":"m" OR "size":"s" )
        """)

      default:
        XCTFail("Unexpected case")
      }
    }

  }

  func testBuildHierarchicalQueries() {

    let query = Query()

    let colorGroup = FilterGroup.And(filters: [Filter.Facet(attribute: "color", stringValue: "red")], name: "color")

    let hierarchicalGroup = FilterGroup.And(filters: [Filter.Facet(attribute: "category.lvl2", stringValue: "a > b > c")], name: "h")

    let filterGroups: [FilterGroupType] = [colorGroup, hierarchicalGroup]

    let hierarchicalAttributes = (0...3)
      .map { "category.lvl\($0)" }
      .map(Attribute.init(rawValue:))

    let hierarchicalFilters: [Filter.Facet] = [
      .init(attribute: "category.lvl0", stringValue: "a"),
      .init(attribute: "category.lvl1", stringValue: "a > b"),
      .init(attribute: "category.lvl2", stringValue: "a > b > c")
    ]

    let queryBuilder = QueryBuilder(query: query,
                                    disjunctiveFacets: [],
                                    filterGroups: filterGroups,
                                    hierarchicalAttributes: hierarchicalAttributes,
                                    hierachicalFilters: hierarchicalFilters)

    let queries = queryBuilder.build()

    XCTAssertEqual(queries.count, hierarchicalAttributes.count + 1)

    XCTAssertEqual(queries[1].filters, "( \"color\":\"red\" )")
    XCTAssertEqual(queries[1].facets, ["category.lvl0"])

    XCTAssertEqual(queries[2].filters, "( \"color\":\"red\" ) AND ( \"category.lvl0\":\"a\" )")
    XCTAssertEqual(queries[2].facets, ["category.lvl1"])

    XCTAssertEqual(queries[3].filters, "( \"color\":\"red\" ) AND ( \"category.lvl1\":\"a > b\" )")
    XCTAssertEqual(queries[3].facets, ["category.lvl2"])

    XCTAssertEqual(queries[4].filters, "( \"color\":\"red\" ) AND ( \"category.lvl2\":\"a > b > c\" )")
    XCTAssertEqual(queries[4].facets, ["category.lvl3"])

  }

}
