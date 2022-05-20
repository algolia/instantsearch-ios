//
//  FacetListInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import AlgoliaSearchClient
import XCTest

class FacetListInteractorTests: XCTestCase {

  class TestController: FacetListController {

    typealias Item = Facet

    var onClick: ((Facet) -> Void)?
    var didReload: (() -> Void)?
    var selectableItems: [(item: Facet, isSelected: Bool)] = []

    func setSelectableItems(selectableItems: [(item: Facet, isSelected: Bool)]) {
      self.selectableItems = selectableItems
    }

    func reload() {
      didReload?()
    }

  }

  func testFacetListInteractorConstructor() {
    let defaultMultipleSelectionInteractor = FacetListInteractor()
    XCTAssertEqual(defaultMultipleSelectionInteractor.selectionMode, .multiple)

    let singleSelectionFacetInteractor = FacetListInteractor(selectionMode: .single)
    XCTAssertEqual(singleSelectionFacetInteractor.selectionMode, .single)

    let multipleSelectionFacetInteractor = FacetListInteractor(selectionMode: .multiple)
    XCTAssertEqual(multipleSelectionFacetInteractor.selectionMode, .multiple)
  }

  func testConnectFilterState() {

    let interactor = FacetListInteractor(selectionMode: .single)

    interactor.items = [
      Facet(value: "cat1", count: 10, highlighted: nil),
      Facet(value: "cat2", count: 5, highlighted: nil),
      Facet(value: "cat3", count: 5, highlighted: nil)
    ]

    let filterState = FilterState()

    interactor.connectFilterState(filterState, with: "categories", operator: .and)

    let groupID: FilterGroup.ID = .and(name: "categories")

    // Interactor -> FilterState
    interactor.computeSelections(selectingItemForKey: "cat1")

    XCTAssertTrue(filterState.contains(Filter.Facet(attribute: "categories", stringValue: "cat1"), inGroupWithID: groupID))

    // FilterState -> Interactor

    filterState.notify(.add(filter: Filter.Facet(attribute: "categories", stringValue: "cat2"), toGroupWithID: groupID))

    XCTAssertEqual(interactor.selections, ["cat1", "cat2"])

  }

  func testConnectSearcher() {
    let interactor = FacetListInteractor(selectionMode: .single)

    let query = Query()
    let searcher = HitsSearcher(client: .init(appID: "", apiKey: ""), indexName: "", query: query)

    interactor.connectSearcher(searcher, with: "type")

    do {
      let results: SearchResponse = try JSONDecoder().decode(fromResource: "SearchResultFacets", withExtension: "json")

      searcher.onResults.fire(results)

      let expectedFacets: Set<Facet> = [
        .init(value: "book", count: 357, highlighted: nil),
        .init(value: "electronics", count: 184, highlighted: nil),
        .init(value: "gifts", count: 27, highlighted: nil),
        .init(value: "office", count: 28, highlighted: nil)
      ]

      XCTAssertEqual(Set(interactor.items), expectedFacets)

    } catch let error {
      XCTFail(error.localizedDescription)
    }

  }
  
  @available(*, deprecated, message: "Test to remove when MulstIndexSearcher obsoleted")
  func testConnectMultiIndexSearcher() {
    let interactor = FacetListInteractor(selectionMode: .single)

    let searcher = MultiIndexSearcher(appID: "", apiKey: "", indexNames: ["index1", "index2"])

    interactor.connectSearcher(searcher, with: "kind", queryIndex: 1)

    do {
      let results1: SearchResponse = try JSONDecoder().decode(fromResource: "SearchResultFacets", withExtension: "json")
      let results2: SearchResponse = try JSONDecoder().decode(fromResource: "SearchResultFacets2", withExtension: "json")

      let searchResponses = SearchesResponse(results: [results1, results2])
      
      searcher.onResults.fire(searchResponses)

      let expectedFacets: Set<Facet> = [
        .init(value: "gadgets", count: 111, highlighted: nil),
        .init(value: "stuff", count: 98, highlighted: nil),
        .init(value: "things", count: 28, highlighted: nil),
        .init(value: "others", count: 16, highlighted: nil)
      ]

      XCTAssertEqual(Set(interactor.items), expectedFacets)

    } catch let error {
      XCTFail(error.localizedDescription)
    }

  }

}
