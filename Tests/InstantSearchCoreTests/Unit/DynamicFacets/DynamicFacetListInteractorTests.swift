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
    
    func facets(of raw: (String, Int)...) -> [Facet] {
      raw.map { Facet(value: $0.0, count: $0.1) }
    }
    
    var response = SearchResponse()
        
    response.facets = [
      "size": facets(of: ("s", 10)),
      "brand": facets(of: ("samsung", 5), ("sony", 4), ("philips", 12)),
    ]
    response.disjunctiveFacets = [
      "size": facets(of: ("s", 10), ("m", 20), ("l", 30), ("xl", 40)),
      "color": facets(of: ("red", 5), ("green", 10), ("blue", 15))
    ]
    response.renderingContent = try! RenderingContent(json: [
      "facetOrdering": [
        "facets": [
          "order": [
            "color",
            "size",
            "brand",
          ],
        ],
      ],
    ])
    
    interactor.update(with: response)
    
    XCTAssertEqual(interactor.orderedFacets.count, 3)
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "size",
                                                                     facets: facets(of: ("s", 10), ("m", 20), ("l", 30), ("xl", 40)))))
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "brand",
                                                                     facets: facets(of: ("samsung", 5), ("sony", 4), ("philips", 12)))))
    XCTAssertTrue(interactor.orderedFacets.contains(AttributedFacets(attribute: "color",
                                                                     facets: facets(of: ("red", 5), ("green", 10), ("blue", 15)))))

  }
  
}
