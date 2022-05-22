//
//  FilterNumericComparisonDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 16/04/2022.
//

import Foundation
import InstantSearchCore

class FilterNumericComparisonDemoController {

  let searcher: HitsSearcher
  let filterState: FilterState
  let clearFilterConnector: FilterClearConnector

  let yearConnector: FilterComparisonConnector<Int>
  let priceConnector: FilterComparisonConnector<Double>

  init() {
    searcher = HitsSearcher(client: .instantSearch,
                            indexName: .filterNumericComparison)
    filterState = .init()
    clearFilterConnector = .init(filterState: filterState)
    yearConnector = .init(searcher: searcher,
                          filterState: filterState,
                          attribute: "year",
                          numericOperator: .greaterThanOrEqual,
                          number: 2014,
                          bounds: nil,
                          operator: .and)

    priceConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price",
                           numericOperator: .greaterThanOrEqual,
                           number: 0,
                           bounds: nil,
                           operator: .and)
    setup()
  }

  private func setup() {
    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
