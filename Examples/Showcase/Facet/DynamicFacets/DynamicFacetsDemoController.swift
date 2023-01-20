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

  static let helpMessage = "Type \"6\", \"61\" or \"616\" to trigger a rule"

  init<SBC: SearchBoxController, DFC: DynamicFacetListController>(searchBoxController: SBC,
                                                                  dynamicFacetListController: DFC) {
    Logger.minSeverityLevel = .trace
    searcher = .init(client: .init(appID: "",
                                   apiKey: ""),
                     indexName: "")
    filterState = .init()
    
    searchBoxConnector = .init(searcher: searcher, controller: searchBoxController)
    dynamicFacetListConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      selectionModeForAttribute: [:],
                                      defaultSelectionMode: .multiple,
                                      filterGroupForAttribute: [:],
                                      defaultFilterGroupType: .or,
                                      controller: dynamicFacetListController)
    
    searcher.request.query.facets = ["*"]
    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
