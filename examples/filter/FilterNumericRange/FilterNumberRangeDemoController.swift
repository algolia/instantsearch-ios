//
//  FilterNumberRangeDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

class FilterNumberRangeDemoController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  
  let rangeConnector: NumberRangeConnector<Double>
  
  init() {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()
    rangeConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price")
    searcher.connectFilterState(filterState)
    searcher.search()
    
  }
  
}
