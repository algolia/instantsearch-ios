//
//  HierachicalMenuSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class HierachicalMenuSnippets {
    
  func widgetSnippet() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()
    
    searcher.connectFilterState(filterState)
    
    let hierarchicalAttributes: [Attribute] = [
      "hierarchicalCategories.lvl0",
      "hierarchicalCategories.lvl1",
      "hierarchicalCategories.lvl2",
    ]
    
    let hierarchicalTableViewController: HierarchicalTableViewController = .init(tableView: UITableView())
        
    let hierachicalConnector: HierarchicalConnector = .init(searcher: searcher,
                                                            filterState: filterState,
                                                            hierarchicalAttributes: hierarchicalAttributes,
                                                            separator: " > ",
                                                            controller: hierarchicalTableViewController,
                                                            presenter: DefaultPresenter.Hierarchical.present)
    searcher.search()
    
    _ = hierachicalConnector
    
  }
  
  func advancedSnippet() {
    
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()
    
    let hierarchicalAttributes: [Attribute] = [
      "hierarchicalCategories.lvl0",
      "hierarchicalCategories.lvl1",
      "hierarchicalCategories.lvl2",
    ]
    
    let hierarchicalTableViewController: HierarchicalTableViewController = .init(tableView: UITableView())
    
    let hierarchicalInteractor: HierarchicalInteractor = .init(hierarchicalAttributes: hierarchicalAttributes,
                                                               separator: " > ")
    
    searcher.connectFilterState(filterState)
    hierarchicalInteractor.connectSearcher(searcher: searcher)
    hierarchicalInteractor.connectFilterState(filterState)
    hierarchicalInteractor.connectController(hierarchicalTableViewController)

    searcher.search()
    
  }
  
}
#endif
