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
    searcher = .init(client: .init(appID: "APP_ID",
                                   apiKey: "API_KEY"),
                     indexName: "dev_sss_products_uae_en")
    filterState = .init()
    searchBoxConnector = .init(searcher: searcher, controller: searchBoxController)
    dynamicFacetListConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      selectionModeForAttribute: [
                                        "c_gender": .multiple,
                                        "category_hierarchy.lvl1": .single,
                                      ],
                                      filterGroupForAttribute: [
                                        "c_gender": ("c_gender", .or),
//                                        "categoryHierarchy.lvl0": ("categoryHierarchy.lvl0", .and),
                                        "categoryHierarchy.lvl1": ("categoryHierarchy.lvl1", .and),
                                      ],
                                      controller: dynamicFacetListController)
    searcher.request.query.facets = [
      "c_gender",
//      "categoryHierarchy.lvl0",
      "categoryHierarchy.lvl1",
    ]
    searcher.connectFilterState(filterState)
    searcher.search()
  }
}
