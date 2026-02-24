//
//  DynamicFacetListInteractorTests.swift
//
//
//  Created by Vladislav Fitc on 12/10/2022.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class DynamicFacetListInteractorTests: XCTestCase {
  func testDisjunctiveFacetsPropagation() {
    let interactor = DynamicFacetListInteractor()

    func facetCounts(of raw: (String, Int)...) -> [String: Int] {
      Dictionary(uniqueKeysWithValues: raw.map { ($0.0, $0.1) })
    }

    func facetHits(of raw: (String, Int)...) -> [FacetHits] {
      raw.map { FacetHits(value: $0.0, highlighted: $0.0, count: $0.1) }
    }

    var response = makeSearchResponse()

    response.facets = [
      "size": facetCounts(of: ("s", 10)),
      "brand": facetCounts(of: ("samsung", 5), ("sony", 4), ("philips", 12))
    ]
    response.disjunctiveFacets = [
      "size": facetCounts(of: ("s", 10), ("m", 20), ("l", 30), ("xl", 40)),
      "color": facetCounts(of: ("red", 5), ("green", 10), ("blue", 15))
    ]
    response.renderingContent = try! RenderingContent(json: [
      "facetOrdering": [
        "facets": [
          "order": [
            "color",
            "size",
            "brand"
          ]
        ]
      ]
    ])

    interactor.update(with: response)

    XCTAssertEqual(interactor.orderedFacets.count, 3)
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "size",
                                                                     facets: facetHits(of: ("s", 10), ("m", 20), ("l", 30), ("xl", 40)))))
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "brand",
                                                                     facets: facetHits(of: ("samsung", 5), ("sony", 4), ("philips", 12)))))
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "color",
                                                                     facets: facetHits(of: ("red", 5), ("green", 10), ("blue", 15)))))
  }
}
