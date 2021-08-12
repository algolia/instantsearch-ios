//
//  FacetFilterListSnippets.swift
//  
//
//  Created by Vladislav Fitc on 07/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class FacetFilterListSnippets {
    
  func widgetExample() {
    let searcher: HitsSearcher = HitsSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let filterState = FilterState()
    let filters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Facet> = .init(tableView: filterListTableView)
    
    let filterListConnector = FacetFilterListConnector(facetFilters: filters,
                                                       selectionMode: .multiple,
                                                       filterState: filterState,
                                                       operator: .and,
                                                       groupName: "Facet Filters",
                                                       controller: filterListController)
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
    _ = filterListConnector

  }
  
  func advancedExample() {
    let searcher: HitsSearcher = HitsSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState = FilterState()
    
    let filters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }
    
    let filterListTableView: UITableView = .init()
    let filterListController: FilterListTableController<Filter.Facet> = .init(tableView: filterListTableView)
    
    let filterListInteractor = FacetFilterListInteractor(items: filters, selectionMode: .multiple)
    
    filterListInteractor.connectFilterState(filterState, operator: .and, groupName: "Facet Filters")
    filterListInteractor.connectController(filterListController)

    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
#endif
