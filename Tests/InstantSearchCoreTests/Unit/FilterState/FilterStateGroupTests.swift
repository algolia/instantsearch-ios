//
//  FilterStateGroupTests.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 22/01/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FilterStateGroupTests: XCTestCase {

  func testOrGroupAddAll() {
    var filterState = GroupsStorage()
    let group = FilterGroup.ID.or(name: "group", filterType: .facet)
    let filter1 = Filter.Facet(attribute: "category", value: "table")
    let filter2 = Filter.Facet(attribute: "category", value: "chair")
    filterState.addAll(filters: [filter1, filter2], toGroupWithID: group)
    XCTAssertTrue(filterState.contains(filter1))
    XCTAssertTrue(filterState.contains(filter2))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "category":"chair" OR "category":"table" )
        """)
  }

  func testAndGroupAddAll() {
    var filterState = GroupsStorage()
    let group = FilterGroup.ID.and(name: "group")
    let filterPrice = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterSize = Filter.Numeric(attribute: "size", operator: .greaterThan, value: 20)
    filterState.addAll(filters: [filterPrice, filterSize], toGroupWithID: group)
    XCTAssertTrue(filterState.contains(filterPrice))
    XCTAssertTrue(filterState.contains(filterSize))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "price" > 10.0 AND "size" > 20.0 )
        """)
  }

}
