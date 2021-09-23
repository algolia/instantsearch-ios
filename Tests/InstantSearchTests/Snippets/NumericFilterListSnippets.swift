//
//  NumericFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class NumericFilterListSnippets {
  
  func widgetExample() {
    
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Numeric] = [
      .init(attribute: "price", operator: .lessThan, value: 5),
      .init(attribute: "price", range: 5...10),
      .init(attribute: "price", range: 10...25),
      .init(attribute: "price", range: 25...100),
      .init(attribute: "price", operator: .greaterThan, value: 100)
    ]
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Numeric> = .init(tableView: filterListTableView)
    
    let filterListConnector = NumericFilterListConnector(numericFilters: filters,
                                                         selectionMode: .multiple,
                                                         filterState: filterState,
                                                         operator: .and,
                                                         groupName: "Numeric Filters",
                                                         controller: filterListController)
    
    searcher.connectFilterState(filterState)
    searcher.search()

    _ = filterListConnector
    
  }
  
  func advancedExample() {
    
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Numeric] = [
      .init(attribute: "price", operator: .lessThan, value: 5),
      .init(attribute: "price", range: 5...10),
      .init(attribute: "price", range: 10...25),
      .init(attribute: "price", range: 25...100),
      .init(attribute: "price", operator: .greaterThan, value: 100)
    ]
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Numeric> = .init(tableView: filterListTableView)
    let filterListInteractor = NumericFilterListInteractor(items: filters,
                                                           selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState,
                                            operator: .and,
                                            groupName: "Numeric Filters")
    filterListInteractor.connectController(filterListController)

    searcher.connectFilterState(filterState)
    searcher.search()
  }
    
}
#endif
