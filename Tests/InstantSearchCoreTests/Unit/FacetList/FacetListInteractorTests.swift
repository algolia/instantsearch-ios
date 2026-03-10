//
//  FacetListInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearch
@testable import InstantSearchCore
import XCTest

class FacetListInteractorTests: XCTestCase {
  class TestController: FacetListController {
    typealias Item = InstantSearchCore.FacetHits

    var onClick: ((InstantSearchCore.FacetHits) -> Void)?
    var didReload: (() -> Void)?
    var selectableItems: [(item: InstantSearchCore.FacetHits, isSelected: Bool)] = []

    func setSelectableItems(selectableItems: [(item: InstantSearchCore.FacetHits, isSelected: Bool)]) {
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
      InstantSearchCore.FacetHits(value: "cat1", highlighted: "cat1", count: 10),
      InstantSearchCore.FacetHits(value: "cat2", highlighted: "cat2", count: 5),
      InstantSearchCore.FacetHits(value: "cat3", highlighted: "cat3", count: 5)
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

  func testConnectSearcher() throws {
    let interactor = FacetListInteractor(selectionMode: .single)

    let query = SearchSearchParamsObject()
    let searcher = try HitsSearcher(appID: "testAppID", apiKey: "testApiKey", indexName: "", query: query)

    interactor.connectSearcher(searcher, with: "type")

    do {
      let results: SearchResponse<SearchHit> = try JSONDecoder().decode(fromResource: "SearchResultFacets", withExtension: "json")

      searcher.onResults.fire(results)

      let expectedFacets: Set<InstantSearchCore.FacetHits> = [
        .init(value: "book", highlighted: "book", count: 357),
        .init(value: "electronics", highlighted: "electronics", count: 184),
        .init(value: "gifts", highlighted: "gifts", count: 27),
        .init(value: "office", highlighted: "office", count: 28)
      ]

      XCTAssertEqual(Set(interactor.items), expectedFacets)

    } catch {
      XCTFail(error.localizedDescription)
    }
  }

}
