//
//  FilterListDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class FilterListDemoController<Filter: FilterType & Hashable> {

  let searcher: HitsSearcher
  let filterState: FilterState
  let clearFilterConnector: FilterClearConnector
  let filterListConnector: FilterListConnector<Filter>

  init<Controller: SelectableListController>(filters: [Filter],
                                             controller: Controller,
                                             selectionMode: SelectionMode) where Controller.Item == Filter {
    searcher = HitsSearcher(client: .instantSearch,
                            indexName: .filterList)
    filterState = .init()
    clearFilterConnector = .init(filterState: filterState)
    filterListConnector = .init(filterState: filterState,
                                filters: filters,
                                selectionMode: selectionMode,
                                operator: .or,
                                groupName: "filters",
                                controller: controller)
    searcher.isDisjunctiveFacetingEnabled = false
    searcher.search()
    searcher.connectFilterState(filterState)
  }

}
