//
//  NumericFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class NumericFilterListSnippets {
  
  let interactor: NumericFilterListInteractor = .init()
  let connector: NumericFilterListConnector = .init(filterState: .init(), operator: .and, groupName: "")
  
  func widgetExample() {
    
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [NumericFilter] = [
      .init(attribute: "price", operator: .lessThan, value: 5),
      .init(attribute: "price", range: 5...10),
      .init(attribute: "price", range: 10...25),
      .init(attribute: "price", range: 25...100),
      .init(attribute: "price", operator: .greaterThan, value: 100)
    ]
    
    
    let filterListConnector = NumericFilterListConnector(numericFilters: filters,
                                                         selectionMode: .multiple,
                                                         filterState: filterState,
                                                         operator: .and,
                                                         groupName: "Numeric Filters")
    
    searcher.connectFilterState(filterState)
    searcher.search()

    _ = filterListConnector
    
  }
  
  func advancedExample() {
    
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [NumericFilter] = [
      .init(attribute: "price", operator: .lessThan, value: 5),
      .init(attribute: "price", range: 5...10),
      .init(attribute: "price", range: 10...25),
      .init(attribute: "price", range: 25...100),
      .init(attribute: "price", operator: .greaterThan, value: 100)
    ]
    
    
    let filterListInteractor = NumericFilterListInteractor(items: filters,
                                                           selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState,
                                            operator: .and,
                                            groupName: "Numeric Filters")
      
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
  func connectViewConnector() {
    let filterListConnector: NumericFilterListConnector = /*...*/ self.connector
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<NumericFilter> = .init(tableView: filterListTableView)
    filterListConnector.interactor.connectController(filterListController)
  }
  
  func connectViewInteractor() {
    let filterListInteractor: NumericFilterListInteractor = /*...*/ self.interactor
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<NumericFilter> = .init(tableView: filterListTableView)
    filterListInteractor.connectController(filterListController)
  }

  
}

