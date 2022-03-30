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
  let queryInputConnector: QueryInputConnector
  let DynamicFacetListConnector: DynamicFacetListConnector<HitsSearcher>
  let filterState: FilterState

  init<QIC: QueryInputController, DFC: DynamicFacetListController>(queryInputController: QIC,
                                                                DynamicFacetListController: DFC) {
    searcher = .init(client: .init(appID: "RVURKQXRHU",
                                   apiKey: "937e4e6ec422ff69fe89b569dba30180"),
                     indexName: "test_facet_ordering")
    filterState = .init()
    queryInputConnector = .init(searcher: searcher, controller: queryInputController)
    DynamicFacetListConnector = .init(searcher: searcher,
                                   filterState: filterState,
                                   selectionModeForAttribute: [
                                    "color": .multiple,
                                    "country": .multiple
                                   ],
                                   filterGroupForAttribute: [
                                    "brand": ("brand", .or),
                                    "color" : ("color", .or),
                                    "size": ("size", .or),
                                    "country": ("country", .or)
                                   ],
                                   controller: DynamicFacetListController)
    searcher.request.query.facets = ["brand", "color", "size", "country"]
    searcher.connectFilterState(filterState)
    searcher.search()
  }
      
}
