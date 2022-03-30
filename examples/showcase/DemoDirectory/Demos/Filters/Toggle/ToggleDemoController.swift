//
//  ToggleDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class ToggleDemoController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  
  let sizeConstraintConnector: FilterToggleConnector<Filter.Numeric>
  let vintageConnector: FilterToggleConnector<Filter.Tag>
  let couponConnector: FilterToggleConnector<Filter.Facet>
  
  init(sizeConstraintButtonController: SelectableFilterButtonController<Filter.Numeric>,
       vintageButtonController: SelectableFilterButtonController<Filter.Tag>,
       couponSwitchController: FilterSwitchController<Filter.Facet>) {
    searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_filter_toggle")
    filterState = .init()
    
    // Size constraint button
    let sizeConstraintFilter = Filter.Numeric(attribute: "size", operator: .greaterThan, value: 40)
    sizeConstraintConnector = .init(filterState: filterState,
                                    filter: sizeConstraintFilter,
                                    controller: sizeConstraintButtonController)

    // Vintage tag button
    let vintageFilter = Filter.Tag(value: "vintage")
    vintageConnector = .init(filterState: filterState,
                             filter: vintageFilter,
                             controller: vintageButtonController)

    // Coupon switch
    let couponFacet = Filter.Facet(attribute: "promotions", stringValue: "coupon")
    couponConnector = .init(filterState: filterState,
                            filter: couponFacet,
                            controller: couponSwitchController)

    
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
  
}
