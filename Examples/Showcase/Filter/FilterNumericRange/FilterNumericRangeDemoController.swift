//
//  FilterNumericRangeDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

class FilterNumericRangeDemoController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  let filterClearConnector: FilterClearConnector
  
  let rangeConnector: NumberRangeConnector<Double>
  
  init() {
    self.searcher = HitsSearcher(client: .instantSearch, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()
    self.filterClearConnector = .init(filterState: filterState)
    rangeConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price")
    searcher.connectFilterState(filterState)
    searcher.search()
    
  }
  
}
