//
//  FacetsOrdererTests.swift
//
//
//  Created by Vladislav Fitc on 14/04/2021.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetsOrdererTests: XCTestCase {
  let facets: [String: [FacetHits]] = [
    "size": [
      FacetHits(value: "XS", count: 82),
      FacetHits(value: "L", count: 81),
      FacetHits(value: "XXXL", count: 73),
      FacetHits(value: "XXL", count: 71),
      FacetHits(value: "M", count: 67),
      FacetHits(value: "S", count: 67),
      FacetHits(value: "XL", count: 67)
    ],
    "brand": [
      FacetHits(value: "Dyson", count: 53),
      FacetHits(value: "Sony", count: 53),
      FacetHits(value: "Apple", count: 51),
      FacetHits(value: "Uniqlo", count: 43)
    ],
    "color": [
      FacetHits(value: "yellow", count: 65),
      FacetHits(value: "blue", count: 63),
      FacetHits(value: "red", count: 58),
      FacetHits(value: "violet", count: 55),
      FacetHits(value: "orange", count: 54),
      FacetHits(value: "green", count: 48)
    ],
    "country": [
      FacetHits(value: "Spain", count: 31),
      FacetHits(value: "Finland", count: 27),
      FacetHits(value: "Germany", count: 27),
      FacetHits(value: "UK", count: 26),
      FacetHits(value: "Italy", count: 25),
      FacetHits(value: "France", count: 23),
      FacetHits(value: "Denmark", count: 22),
      FacetHits(value: "USA", count: 19)
    ]
  ]

  func withOrder(_ facetOrder: SearchFacetOrdering) -> [AttributedFacets] {
    return FacetsOrderer(facetOrder: facetOrder, facets: facets)()
  }

  func testStrictFacetsOrder() {
    let facets: [String] = ["size", "brand", "color", "country"].shuffled()
    let order = SearchFacetOrdering(facets: .init(order: facets), values: [:])
    XCTAssertEqual(withOrder(order).map(\.attribute), facets)
  }

  func testPartialFacetsOrder() {
    let facets: [String] = ["size", "country"]
    let order = SearchFacetOrdering(facets: .init(order: facets), values: [:])
    XCTAssertEqual(withOrder(order).map(\.attribute), facets)
  }

  func testStrictFacetValuesOrder() {
    let countries = ["UK", "France", "USA", "Germany", "Finland", "Denmark", "Italy", "Spain"].shuffled()
    let order = SearchFacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .hidden)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries)
  }

  func testPartialFacetValuesOrder() {
    let countries = ["UK", "France", "USA"].shuffled()
    let order = SearchFacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .hidden)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries)
  }

  func testPartiallyStrictFacetValuesOrder() {
    let countries = ["UK", "France", "USA"]
    let order = SearchFacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .alpha)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries + ["Germany", "Finland", "Denmark", "Italy", "Spain"].sorted())
  }

  func testSortFacetValuesByCount() {
    let expectedFacetValues = facets["country"]?.sorted(by: { $0.count > $1.count }).map(\.value)
    let order = SearchFacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: [], sortRemainingBy: .count)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), expectedFacetValues)
  }
}
