//
//  FilterGroupTests.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 16/01/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class FilterGroupTests: XCTestCase {

  func testAndGroupSingle() {

    let group = FilterGroup.And(filters: [
      Filter.Tag(value: "tag")
    ])

    XCTAssertEqual(group.sqlForm, "( \"_tags\":\"tag\" )")

  }

  func testAndGroupMultiple() {

    let filters: [FilterType] = [
      Filter.Tag(value: "tag"),
      Filter.Numeric(attribute: "size", operator: .equals, value: 40),
      Filter.Facet(attribute: "brand", stringValue: "sony")
    ]
    let group = FilterGroup.And(filters: filters)

    XCTAssertEqual(group.sqlForm, "( \"_tags\":\"tag\" AND \"size\" = 40.0 AND \"brand\":\"sony\" )")

  }

  func testOrGroupSingle() {

    let group = FilterGroup.Or(filters: [Filter.Facet(attribute: "brand", stringValue: "philips")])

    XCTAssertEqual(group.sqlForm, "( \"brand\":\"philips\" )")

  }

  func testOrGroupMultiple() {

    let filters = [
      Filter.Facet(attribute: "brand", stringValue: "philips"),
      Filter.Facet(attribute: "diagonal", floatValue: 42),
      Filter.Facet(attribute: "featured", boolValue: true)
    ]

    let group = FilterGroup.Or(filters: filters)

    XCTAssertEqual(group.sqlForm, "( \"brand\":\"philips\" OR \"diagonal\":\"42.0\" OR \"featured\":\"true\" )")

  }

}
