//
//  FilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 01/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class FilterListSnippets {
  
  func facetFilterList() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<FacetFilter> = .init(tableView: filterListTableView)
    
    let filterListConnector = FacetFilterListConnector(facetFilters: filters,
                                                       selectionMode: .multiple,
                                                       filterState: filterState,
                                                       operator: .and,
                                                       groupName: "Facet Filters")
    
    searcher.connectFilterState(filterState)
    filterListConnector.interactor.connectController(filterListController)
    
  }
  
  func numericFilterList() {
    
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
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<NumericFilter> = .init(tableView: filterListTableView)
    
    let filterListConnector = NumericFilterListConnector(numericFilters: filters,
                                                         selectionMode: .multiple,
                                                         filterState: filterState,
                                                         operator: .and,
                                                         groupName: "Numeric Filters")
    
    searcher.connectFilterState(filterState)
    filterListConnector.interactor.connectController(filterListController)
    
  }
  
  func tagFilterList() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")

    let filterState = FilterState()
    
    let filters: [TagFilter] = [
      "coupon",
      "free shipping",
      "free return",
      "on sale",
      "no exchange"
    ]
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<TagFilter> = .init(tableView: filterListTableView)
    
    let filterListConnector = TagFilterListConnector(tagFilters: filters,
                                                     selectionMode: .multiple,
                                                     filterState: filterState,
                                                     operator: .and,
                                                     groupName: "Tag Filters")
    
    searcher.connectFilterState(filterState)
    filterListConnector.interactor.connectController(filterListController)
  }
  
  
}
