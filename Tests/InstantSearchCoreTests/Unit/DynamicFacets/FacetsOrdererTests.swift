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
  let facets: [Attribute: [Facet]] = [
    "size": [
      Facet(value: "XS", count: 82),
      Facet(value: "L", count: 81),
      Facet(value: "XXXL", count: 73),
      Facet(value: "XXL", count: 71),
      Facet(value: "M", count: 67),
      Facet(value: "S", count: 67),
      Facet(value: "XL", count: 67)
    ],
    "brand": [
      Facet(value: "Dyson", count: 53),
      Facet(value: "Sony", count: 53),
      Facet(value: "Apple", count: 51),
      Facet(value: "Uniqlo", count: 43)
    ],
    "color": [
      Facet(value: "yellow", count: 65),
      Facet(value: "blue", count: 63),
      Facet(value: "red", count: 58),
      Facet(value: "violet", count: 55),
      Facet(value: "orange", count: 54),
      Facet(value: "green", count: 48)
    ],
    "country": [
      Facet(value: "Spain", count: 31),
      Facet(value: "Finland", count: 27),
      Facet(value: "Germany", count: 27),
      Facet(value: "UK", count: 26),
      Facet(value: "Italy", count: 25),
      Facet(value: "France", count: 23),
      Facet(value: "Denmark", count: 22),
      Facet(value: "USA", count: 19)
    ]
  ]

  func withOrder(_ facetOrder: FacetOrdering) -> [AttributedFacets] {
    return FacetsOrderer(facetOrder: facetOrder, facets: facets)()
  }

  func testStrictFacetsOrder() {
    let facets: [Attribute] = ["size", "brand", "color", "country"].shuffled()
    let order = FacetOrdering(facets: .init(order: facets), values: [:])
    XCTAssertEqual(withOrder(order).map(\.attribute), facets)
  }

  func testPartialFacetsOrder() {
    let facets: [Attribute] = ["size", "country"]
    let order = FacetOrdering(facets: .init(order: facets), values: [:])
    XCTAssertEqual(withOrder(order).map(\.attribute), facets)
  }

  func testStrictFacetValuesOrder() {
    let countries = ["UK", "France", "USA", "Germany", "Finland", "Denmark", "Italy", "Spain"].shuffled()
    let order = FacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .hidden)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries)
  }

  func testPartialFacetValuesOrder() {
    let countries = ["UK", "France", "USA"].shuffled()
    let order = FacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .hidden)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries)
  }

  func testPartiallyStrictFacetValuesOrder() {
    let countries = ["UK", "France", "USA"]
    let order = FacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: countries, sortRemainingBy: .alpha)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), countries + ["Germany", "Finland", "Denmark", "Italy", "Spain"].sorted())
  }

  func testSortFacetValuesByCount() {
    let expectedFacetValues = facets["country"]?.sorted(by: { $0.count > $1.count }).map(\.value)
    let order = FacetOrdering(facets: .init(order: ["country"]), values: ["country": .init(order: [], sortRemainingBy: .count)])
    XCTAssertEqual(withOrder(order).first(where: { $0.attribute == "country" })?.facets.map(\.value), expectedFacetValues)
  }
}
