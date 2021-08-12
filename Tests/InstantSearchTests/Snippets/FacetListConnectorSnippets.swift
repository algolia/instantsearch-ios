//
//  FacetListConnectorSnippets.swift
//  
//
//  Created by Vladislav Fitc on 28/08/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class FacetListConnectorSnippets {
  
  func widgetExample() {
    let searcher: HitsSearcher = HitsSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")

    let filterState: FilterState = .init()

    let categoryTableViewController: UITableViewController = .init()
    let categoryListController: FacetListTableController = .init(tableView: categoryTableViewController.tableView)
    let facetListPresenter: FacetListPresenter = .init(sortBy: [.count(order: .descending)], limit: 5, showEmptyFacets: false)

    let categoryConnector: FacetListConnector = .init(searcher: searcher,
                                                      filterState: filterState,
                                                      attribute: "category",
                                                      selectionMode: .multiple,
                                                      facets: [.init(value: "initial facet", count: 10)],
                                                      persistentSelection: true,
                                                      operator: .and,
                                                      controller: categoryListController,
                                                      presenter: facetListPresenter)
    
    searcher.search()
    
  }
  
  func manualExample() {
    let searcher: HitsSearcher = HitsSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let filterState: FilterState = .init()
    
    let facetListInteractor: FacetListInteractor  = .init(facets: [.init(value: "initial facet", count: 10)], selectionMode: .multiple)
    
    let categoryTableViewController: UITableViewController = .init()
    let categoryListController: FacetListTableController = .init(tableView: categoryTableViewController.tableView)
    let facetListPresenter: FacetListPresenter = .init(sortBy: [.count(order: .descending)], limit: 5, showEmptyFacets: false)

    facetListInteractor.connectSearcher(searcher, with: "category")
    facetListInteractor.connectFilterState(filterState, with: "category", operator: .or)
    facetListInteractor.connectController(categoryListController)
    facetListInteractor.connectController(categoryListController, with: facetListPresenter)
    searcher.connectFilterState(filterState)
    
    searcher.search()
  }
  
  func controllerExample() {
    let connector = FacetListConnector(searcher: .init(appID: "", apiKey: "", indexName: ""), attribute: "", operator: .or)
    let controller = FacetListTableController(tableView: .init())
    let presenter = FacetListPresenter(sortBy: [], limit: 10, showEmptyFacets: true)
    connector.interactor.connectController(controller, with: presenter)
    
    let interactor = FacetListInteractor()
    
    interactor.connectController(controller, with: presenter)
  }
  
}
#endif
