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

  let searchBoxConnector: SearchBoxConnector
  let rangeConnector: NumberRangeConnector<Double>
  let statsConnector: StatsConnector

  init() {
    self.searcher = HitsSearcher(client: .instantSearch,
                                 indexName: .filterNumericComparison)
    self.filterState = .init()
    self.filterClearConnector = .init(filterState: filterState)
    rangeConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price")
    statsConnector = .init(searcher: searcher)
    searchBoxConnector = .init(searcher: searcher)
    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
