//
//  DynamicFacetListDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 18/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation

import InstantSearch

class DynamicFacetListDemoController {
  let searcher: HitsSearcher
  let searchBoxConnector: SearchBoxConnector
  let dynamicFacetListConnector: DynamicFacetListConnector<HitsSearcher>
  let filterState: FilterState
  let searchFilterStateConnection: Connection!

  static let helpMessage = "Type \"6\", \"61\" or \"616\" to trigger a rule"

  init<SBC: SearchBoxController, DFC: DynamicFacetListController>(searchBoxController: SBC,
                                                                  dynamicFacetListController: DFC) {
    searcher = .init(client: .init(appID: "RVURKQXRHU",
                                   apiKey: "937e4e6ec422ff69fe89b569dba30180"),
                     indexName: "test_facet_ordering")
    filterState = .init()
    searchBoxConnector = .init(searcher: searcher, controller: searchBoxController)
    dynamicFacetListConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      selectionModeForAttribute: [
                                        "color": .multiple,
                                        "country": .multiple
                                      ],
                                      filterGroupForAttribute: [
                                        "brand": ("brand", .or),
                                        "color": ("color", .or),
                                        "size": ("size", .or),
                                        "country": ("country", .or)
                                      ],
                                      controller: dynamicFacetListController)
    searcher.request.query.facets = ["brand", "color", "size", "country"]
    searchFilterStateConnection = searcher.connectFilterState(filterState)
    // Filters preselection during the initialization of search controller
    preselectFilters()
    searcher.search()
  }
  
  func preselectFilters() {
    /// Here the Sony brand and yellow color are pre-selected without manipulation with UI components.
    filterState[or: "brand", FacetFilter.self].add(FacetFilter.init(attribute: "brand", stringValue: "Sony"))
    filterState[or: "color", FacetFilter.self].add(FacetFilter.init(attribute: "color", stringValue: "yellow"))
    filterState.notifyChange()
    /// Launch the app to see the filters are applied
  }
  
  func clearFilters() {
    // Remove all filters without notify subscribers about changes
    filterState.removeAll()
    // Force update of the interactor state to appy the new FilterState value
    let interactor = dynamicFacetListConnector.interactor
    interactor.onFacetOrderChanged.fire(interactor.orderedFacets)
  }
}
