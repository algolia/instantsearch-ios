//
//  DynamicFacetListDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 18/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchInsights
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
    searchBoxConnector = .init(searcher: searcher, controller: searchBoxController)

    filterState = .init()
    
    // instantitate filters you get from the deep link
    let preappliedSports = [
      "Football",
      "Basketball",
      "Skateboarding",
      "Swimming",
      "Outdoor",
      "Skiing",
      "Racket Sports",
      "Volleyball",
      "Golf",
      "Cycling",
      "Baseball",
      "Cricket",
    ].map { FacetFilter(attribute: "c_sport", stringValue: $0) }
    
    // add them to the corresponding filter group of the filter state
    filterState[or: "c_sport"].addAll(preappliedSports)

    // same for another filter
    let preappliedGenders = [
      "Men",
      "Unisex",
    ].map { FacetFilter(attribute: "c_gender", stringValue: $0) }
    filterState[or: "c_gender"].addAll(preappliedGenders)
    
    // instantiate the dynamic facet list connector with the corresponding
    dynamicFacetListConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      selectionModeForAttribute: [
                                        "c_sport": .multiple,
                                        "c_gender": .multiple
                                      ],
                                      filterGroupForAttribute: [
                                        "c_sport": ("c_sport", .or),
                                        "c_gender": ("c_gender", .or),
                                      ],
                                      controller: dynamicFacetListController)
    
    searcher.request.query.facets = ["c_sport", "c_gender"]
    searcher.connectFilterState(filterState)
    
    searcher.search()
  }
}
