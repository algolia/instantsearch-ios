//
//  FacetSearchDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 07.04.2022.
//

import Foundation
import InstantSearch

class FacetSearchDemoController {
  
  let facetSearcher: FacetSearcher
  let filterState: FilterState
  let facetListConnector: FacetListConnector
  let queryInputConnector: QueryInputConnector
  
  init<FLC: FacetListController, QIC: QueryInputController>(facetListController: FLC, queryInputController: QIC) {
    filterState = .init()
    facetSearcher = FacetSearcher(client: .demo,
                                  indexName: "mobile_demo_facet_list_search",
                                  facetName: "brand")
    facetListConnector = .init(searcher: facetSearcher,
                               filterState: filterState,
                               attribute: "brand",
                               operator: .or,
                               controller: facetListController)
    queryInputConnector = QueryInputConnector(searcher: facetSearcher,
                                              controller: queryInputController)
    
    facetSearcher.search()
  }
  
}
