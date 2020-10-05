//
//  TagFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit)
import UIKit

class TagFilterListSnippets {
    
  func widgetExample() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")

    let filterState = FilterState()
    
    let filters: [Filter.Tag] = [
      "coupon",
      "free shipping",
      "free return",
      "on sale",
      "no exchange"
    ]
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Tag> = .init(tableView: filterListTableView)

    let filterListConnector = TagFilterListConnector(tagFilters: filters,
                                                     selectionMode: .multiple,
                                                     filterState: filterState,
                                                     operator: .and,
                                                     groupName: "Tag Filters",
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
    
    let filters: [Filter.Tag] = [
      "coupon",
      "free shipping",
      "free return",
      "on sale",
      "no exchange"
    ]
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Tag> = .init(tableView: filterListTableView)

    let filterListInteractor = TagFilterListInteractor(items: filters,
                                                      selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState, operator: .and, groupName: "Tag Filters")
    filterListInteractor.connectController(filterListController)

    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
}
#endif
