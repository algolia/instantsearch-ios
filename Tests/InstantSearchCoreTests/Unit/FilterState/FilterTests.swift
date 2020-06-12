//
//  FilterTests.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 27/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class FilterTests: XCTestCase {

  func testFilterFacetVariants() {
    testFilterFacet(with: "value")
    testFilterFacet(with: 10)
    testFilterFacet(with: true)
  }

  func testFilterFacet(with value: Filter.Facet.ValueType) {
    let attribute: Attribute = "a"
    var facetFilter = Filter.Facet(attribute: attribute, value: value)
    let expectedExpression = "\"\(attribute)\":\"\(value)\""
    XCTAssertEqual(facetFilter.attribute, attribute)
    XCTAssertEqual(facetFilter.sqlForm, expectedExpression)
    XCTAssertFalse(facetFilter.isNegated)
    XCTAssertEqual(facetFilter.value, value)
    // Test inversion
    facetFilter.not()
    XCTAssertTrue(facetFilter.isNegated)
    XCTAssertEqual(facetFilter.sqlForm, "NOT \(expectedExpression)")
  }

  func testFilterNumericComparisonConstruction() {
    let attribute: Attribute = "a"
    let value: Double = 10
    let op: Filter.Numeric.Operator = .equals
    let expectedExpression = """
    "\(attribute)" \(op.rawValue) \(value)
    """
    var numericFilter = Filter.Numeric(attribute: attribute, operator: op, value: value)
    XCTAssertEqual(numericFilter.attribute, attribute)
    XCTAssertEqual(numericFilter.sqlForm, expectedExpression)
    XCTAssertFalse(numericFilter.isNegated)
    // Test inversion
    numericFilter.not()
    XCTAssertTrue(numericFilter.isNegated)
    XCTAssertEqual(numericFilter.sqlForm, "NOT \(expectedExpression)")
  }

  func testFilterNumericRangeConstruction() {
    let attribute: Attribute = "a"
    let value: ClosedRange<Double> = 0...10
    let expectedExpression = """
    "\(attribute)":\(value.lowerBound) TO \(value.upperBound)
    """
    var numericFilter = Filter.Numeric(attribute: attribute, range: value)
    XCTAssertEqual(numericFilter.attribute, attribute)
    XCTAssertEqual(numericFilter.sqlForm, expectedExpression)
    XCTAssertFalse(numericFilter.isNegated)
    // Test inversion
    numericFilter.not()
    XCTAssertTrue(numericFilter.isNegated)
    XCTAssertEqual(numericFilter.sqlForm, "NOT \(expectedExpression)")
  }

  func testTimeStamp() {
    let attribute: Attribute = "beginDate"
    let timeStamp = Date().timeIntervalSince1970
    let numericFilter = Filter.Numeric(attribute: attribute, operator: .greaterThan, value: timeStamp)
    XCTAssertEqual(numericFilter.sqlForm, "\"beginDate\" > \(timeStamp)")
  }

  func testFilterTagConstruction() {
    let value = "a"
    let attribute: Attribute = .tags
    let expectedExpression =  """
    "\(attribute)":"\(value)"
    """
    var tagFilter = Filter.Tag(value: value)
    XCTAssertEqual(tagFilter.attribute, attribute)
    XCTAssertEqual(tagFilter.sqlForm, expectedExpression)
    XCTAssertFalse(tagFilter.isNegated)
    // Test inversion
    tagFilter.not()
    XCTAssertTrue(tagFilter.isNegated)
    XCTAssertEqual(tagFilter.sqlForm, "NOT \(expectedExpression)")
  }

  func testInversion() {

    let boolFacetFilter = Filter.Facet(attribute: "a", value: true)
    XCTAssertFalse(boolFacetFilter.isNegated)
    XCTAssertTrue((!boolFacetFilter).isNegated)
    XCTAssertEqual(!boolFacetFilter, Filter.Facet(attribute: "a", value: true, isNegated: true))

    let numericFacetFilter = Filter.Facet(attribute: "a", value: 1)
    XCTAssertFalse(numericFacetFilter.isNegated)
    XCTAssertTrue((!numericFacetFilter).isNegated)
    XCTAssertEqual(!numericFacetFilter, Filter.Facet(attribute: "a", value: 1, isNegated: true))

    let stringFacetFilter = Filter.Facet(attribute: "a", value: "b")
    XCTAssertFalse(stringFacetFilter.isNegated)
    XCTAssertTrue((!stringFacetFilter).isNegated)
    XCTAssertEqual(!stringFacetFilter, Filter.Facet(attribute: "a", value: "b", isNegated: true))

    let filterTag = Filter.Tag(value: "a")
    XCTAssertFalse(filterTag.isNegated)
    XCTAssertTrue((!filterTag).isNegated)
    XCTAssertEqual(!filterTag, Filter.Tag(value: "a", isNegated: true))

    let comparisonNumericFilter = Filter.Numeric(attribute: "a", operator: .equals, value: 10)
    XCTAssertFalse(comparisonNumericFilter.isNegated)
    XCTAssertTrue((!comparisonNumericFilter).isNegated)
    XCTAssertEqual(!comparisonNumericFilter, Filter.Numeric(attribute: "a", operator: .equals, value: 10, isNegated: true))

    let rangeNumericFilter = Filter.Numeric(attribute: "a", range: 0...10)
    XCTAssertFalse(rangeNumericFilter.isNegated)
    XCTAssertTrue((!rangeNumericFilter).isNegated)
    XCTAssertEqual(!rangeNumericFilter, Filter.Numeric(attribute: "a", range: 0...10, isNegated: true))

  }

}
