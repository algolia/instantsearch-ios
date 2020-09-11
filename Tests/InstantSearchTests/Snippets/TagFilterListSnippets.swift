//
//  TagFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class TagFilterListSnippets {
  
  let interactor: TagFilterListInteractor = .init()
  let connector: TagFilterListConnector = .init(filterState: .init(), operator: .and, groupName: "")
  
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
        
    let filterListConnector = TagFilterListConnector(tagFilters: filters,
                                                     selectionMode: .multiple,
                                                     filterState: filterState,
                                                     operator: .and,
                                                     groupName: "Tag Filters")
    
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
        
    let filterListInteractor = TagFilterListInteractor(items: filters,
                                                      selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState, operator: .and, groupName: "Tag Filters")
    
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
  func connectViewConnector() {
    let filterListConnector: TagFilterListConnector = /*...*/ self.connector
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Tag> = .init(tableView: filterListTableView)
    filterListConnector.interactor.connectController(filterListController)
  }
  
  func connectViewInteractor() {
    let filterListInteractor: TagFilterListInteractor = /*...*/ self.interactor
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Tag> = .init(tableView: filterListTableView)
    filterListInteractor.connectController(filterListController)
  }

}
