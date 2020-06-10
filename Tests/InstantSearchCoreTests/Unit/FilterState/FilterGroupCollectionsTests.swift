//
//  FilterGroupCollectionsTests.swift
//  AlgoliaSearch
//
//  Created by Vladislav Fitc on 09/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class FilterGroupCollectionsTests: XCTestCase {

  func testConversion() {

    let andGroup = FilterGroup.And(filters: [
      Filter.Tag(value: "tag"),
      Filter.Numeric(attribute: "size", operator: .equals, value: 40),
      Filter.Facet(attribute: "brand", stringValue: "sony")
    ] as [FilterType])

    let orGroup = FilterGroup.Or(filters: [
      Filter.Facet(attribute: "brand", stringValue: "philips"),
      Filter.Facet(attribute: "diagonal", floatValue: 42),
      Filter.Facet(attribute: "featured", boolValue: true)
    ])

    let converter = FilterGroupConverter()
    let groups: [FilterGroupType] = [andGroup, orGroup]

    XCTAssertEqual(converter.sql(groups), "( \"_tags\":\"tag\" AND \"size\" = 40.0 AND \"brand\":\"sony\" ) AND ( \"brand\":\"philips\" OR \"diagonal\":\"42.0\" OR \"featured\":\"true\" )")

  }

}
