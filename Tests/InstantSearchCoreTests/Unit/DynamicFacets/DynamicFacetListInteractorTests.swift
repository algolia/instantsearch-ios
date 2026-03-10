//
//  DynamicFacetListInteractorTests.swift
//
//
//  Created by Vladislav Fitc on 12/10/2022.
//

import Foundation
import AlgoliaSearch
@testable import InstantSearchCore
import XCTest

class DynamicFacetListInteractorTests: XCTestCase {
  func testDisjunctiveFacetsPropagation() {
    let interactor = DynamicFacetListInteractor()

    func facetCounts(of raw: (String, Int)...) -> [String: Int] {
      Dictionary(uniqueKeysWithValues: raw.map { ($0.0, $0.1) })
    }

    func facetHits(of raw: (String, Int)...) -> [InstantSearchCore.FacetHits] {
      raw.map { InstantSearchCore.FacetHits(value: $0.0, highlighted: $0.0, count: $0.1) }
    }

    var response = makeSearchResponse()

    response.facets = [
      "size": facetCounts(of: ("s", 10), ("m", 20), ("l", 30), ("xl", 40)),
      "brand": facetCounts(of: ("samsung", 5), ("sony", 4), ("philips", 12)),
      "color": facetCounts(of: ("red", 5), ("green", 10), ("blue", 15))
    ]
    response.renderingContent = SearchRenderingContent(
      facetOrdering: SearchFacetOrdering(
        facets: SearchFacets(order: ["color", "size", "brand"])
      )
    )

    interactor.update(with: response)

    XCTAssertEqual(interactor.orderedFacets.count, 3)

    let orderedAttributes = interactor.orderedFacets.map(\.attribute)
    XCTAssertTrue(orderedAttributes.contains("size"))
    XCTAssertTrue(orderedAttributes.contains("brand"))
    XCTAssertTrue(orderedAttributes.contains("color"))

    func assertFacets(for attribute: String, expected: [(String, Int)]) {
      guard let af = interactor.orderedFacets.first(where: { $0.attribute == attribute }) else {
        XCTFail("Missing attribute \(attribute)")
        return
      }
      let actual = af.facets.map { "\($0.value):\($0.count)" }.sorted()
      let exp = expected.map { "\($0.0):\($0.1)" }.sorted()
      XCTAssertEqual(actual, exp, "Facet values mismatch for \(attribute)")
    }

    assertFacets(for: "size", expected: [("s", 10), ("m", 20), ("l", 30), ("xl", 40)])
    assertFacets(for: "brand", expected: [("samsung", 5), ("sony", 4), ("philips", 12)])
    assertFacets(for: "color", expected: [("red", 5), ("green", 10), ("blue", 15)])
  }
}
