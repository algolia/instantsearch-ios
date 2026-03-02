//
//  FacetListInteractorTests.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 18/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class FacetListPresenterTests: XCTestCase {
  func testCountDescSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "orange", count: 20), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "green", count: 0), true),
      (.init(value: "blue", count: 40), false),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testCountDescNotSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "blue", count: 40), false),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "orange", count: 20), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "black", count: 5), false),
      (.init(value: "green", count: 0), true)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.count(order: .descending)])

    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testCountAscSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "green", count: 0), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "black", count: 5), false),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "blue", count: 40), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.isRefined, .count(order: .ascending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testCountAscNotSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "blue", count: 40), false),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "orange", count: 20), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "black", count: 5), false),
      (.init(value: "green", count: 0), true)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.count(order: .descending)])

    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testNameAscSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "green", count: 0), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "yellow", count: 30), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.isRefined, .alphabetical(order: .ascending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testNameAscNotSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "yellow", count: 30), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.alphabetical(order: .ascending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testNameDescSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "green", count: 0), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "black", count: 5), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.isRefined, .alphabetical(order: .descending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

  func testNameDescNotSelectedOnTop() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "yellow", count: 30), false),
      (.init(value: "black", count: 5), false),
      (.init(value: "blue", count: 40), false),
      (.init(value: "green", count: 0), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "yellow", count: 30), false),
      (.init(value: "red", count: 10), true),
      (.init(value: "orange", count: 20), true),
      (.init(value: "green", count: 0), true),
      (.init(value: "blue", count: 40), false),
      (.init(value: "black", count: 5), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.alphabetical(order: .descending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

//  func testRemoveSelectedValuesWithZeroCount() {
//    var expectedList: [Facet] = []
//
//    expectedList.append(Facet(value: "yellow", count: 30, highlighted: nil))
//    expectedList.append(Facet(value: "red", count: 10, highlighted: nil))
//    expectedList.append(Facet(value: "orange", count: 20, highlighted: nil))
//    expectedList.append(Facet(value: "blue", count: 40, highlighted: nil))
//    expectedList.append(Facet(value: "black", count: 5, highlighted: nil))
//
//    let actualList: [Facet] = refinementListBuilder.getRefinementList(selectedValues: selectedValues,
//                                                                           resultValues: facetValues,
//                                                                           sortBy: [.alphabetical(order: .descending)],
//                                                                           keepSelectedValuesWithZeroCount: false)
//
//    XCTAssertEqual(expectedList, actualList)
//  }

  func testSortWithEqualCounts() {
    let initial: [SelectableItem<FacetHits>] = [
      (.init(value: "blue", count: 10), false),
      (.init(value: "red", count: 10), true),
      (.init(value: "green", count: 5), true),
      (.init(value: "orange", count: 10), true)
    ]

    let expected: [SelectableItem<FacetHits>] = [
      (.init(value: "orange", count: 10), true),
      (.init(value: "red", count: 10), true),
      (.init(value: "green", count: 5), true),
      (.init(value: "blue", count: 10), false)
    ]

    let refinementFacetsPresenter = FacetListPresenter(sortBy: [.isRefined, .count(order: .descending), .alphabetical(order: .ascending)])
    let actual = refinementFacetsPresenter.transform(refinementFacets: initial)

    XCTAssertEqual(expected.map { $0.item }, actual.map { $0.item })
  }

//  func testMergeWithFacetAndRefinementValues() {
//    let actualList = refinementListBuilder.merge(facetValues, withRefinementValues: selectedValues)
//
//    var expectedList: [Facet] = []
//    expectedList.append(contentsOf: facetValues)
//    expectedList.append(Facet(value: "green", count: 0, highlighted: nil)) // The missing one, put count 0
//
//    XCTAssertEqual(expectedList, actualList)
//  }
//
//  func testMergeWithRefinementValues() {
//    let actualList = refinementListBuilder.merge([], withRefinementValues: selectedValues)
//
//    var expectedList: [Facet] = []
//    expectedList.append(Facet(value: "orange", count: 0, highlighted: nil))
//    expectedList.append(Facet(value: "red", count: 0, highlighted: nil))
//    expectedList.append(Facet(value: "green", count: 0, highlighted: nil)) // The missing one, put count 0
//
//    XCTAssertEqual(expectedList, actualList)
//  }
//
//  func testMergeWithFacets() {
//    let actualList = refinementListBuilder.merge(facetValues, withRefinementValues: [])
//
//    var expectedList: [Facet] = []
//    expectedList.append(contentsOf: facetValues)
//
//    XCTAssertEqual(expectedList, actualList)
//  }
//
//  func testMergeWithEmptyValues() {
//    let actualList = refinementListBuilder.merge([], withRefinementValues: [])
//
//    let expectedList: [Facet] = []
//
//    XCTAssertEqual(expectedList, actualList)
//  }
}
