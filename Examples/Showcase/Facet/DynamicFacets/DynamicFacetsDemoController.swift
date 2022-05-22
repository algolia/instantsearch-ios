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
    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
