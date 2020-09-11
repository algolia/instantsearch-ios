//
//  FacetFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class FacetFilterListSnippets {
  
  let interactor: FacetFilterListInteractor = .init()
  let connector: FacetFilterListConnector = .init(filterState: .init(), operator: .and, groupName: "")
  
  func widgetExample() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }
    
    let filterListConnector = FacetFilterListConnector(facetFilters: filters,
                                                       selectionMode: .multiple,
                                                       filterState: filterState,
                                                       operator: .and,
                                                       groupName: "Facet Filters")
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
    _ = filterListConnector

  }
  
  func advancedExample() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }
    
    let filterListInteractor = FacetFilterListInteractor(items: filters, selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState, operator: .and, groupName: "Facet Filters")
    
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
  func connectViewConnector() {
    let filterListConnector: FacetFilterListConnector = /*...*/ self.connector
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Facet> = .init(tableView: filterListTableView)
    filterListConnector.interactor.connectController(filterListController)
  }
  
  func connectViewInteractor() {
    let filterListInteractor: FacetFilterListInteractor = /*...*/ self.interactor
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Facet> = .init(tableView: filterListTableView)
    filterListInteractor.connectController(filterListController)
  }

}
