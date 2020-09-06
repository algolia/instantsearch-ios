//
//  HierachicalMenuSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class HierachicalMenuSnippets {
  
  let hierarchicalInteractor = HierarchicalInteractor(hierarchicalAttributes: [], separator: "")
  let hierarchicalConnector = HierarchicalConnector(searcher: .init(appID: "", apiKey: "", indexName: ""), filterState: .init(), hierarchicalAttributes: [], separator: "")
  
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()
    
    searcher.connectFilterState(filterState)
    
    let hierarchicalAttributes: [Attribute] = [
      "hierarchicalCategories.lvl0",
      "hierarchicalCategories.lvl1",
      "hierarchicalCategories.lvl2",
    ]
    
    let hierachicalConnector: HierarchicalConnector = .init(searcher: searcher,
                                                            filterState: filterState,
                                                            hierarchicalAttributes: hierarchicalAttributes,
                                                            separator: " > ")
    searcher.search()
    
    _ = hierachicalConnector
    
  }
  
  func advancedSnippet() {
    
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()
    
    let hierarchicalAttributes: [Attribute] = [
      "hierarchicalCategories.lvl0",
      "hierarchicalCategories.lvl1",
      "hierarchicalCategories.lvl2",
    ]
    
    let hierarchicalInteractor: HierarchicalInteractor = .init(hierarchicalAttributes: hierarchicalAttributes,
                                                               separator: " > ")
    
    searcher.connectFilterState(filterState)
    hierarchicalInteractor.connectSearcher(searcher: searcher)
    hierarchicalInteractor.connectFilterState(filterState)
    
    searcher.search()
    
  }
  
  func connectControllerConnector() {
    
    let presenter: HierarchicalPresenter = { facets in
       let levels = Set(facets.map { $0.level }).sorted()

       guard !levels.isEmpty else { return facets }

       var output: [HierarchicalFacet] = []

       output.reserveCapacity(facets.count)

       levels.forEach { level in
         let facetsForLevel = facets
           .filter { $0.level == level }
           .sorted { $0.facet.value < $1.facet.value }
         let indexToInsert = output
           .lastIndex { $0.isSelected }
           .flatMap { output.index(after: $0) } ?? output.endIndex
         output.insert(contentsOf: facetsForLevel, at: indexToInsert)
       }

      return output
    }
    
    let hierarchicalConnector: HierarchicalConnector = /*...*/ self.hierarchicalConnector
    let hierarchicalTableViewController: HierarchicalTableViewController = .init(tableView: UITableView())
    hierarchicalConnector.interactor.connectController(hierarchicalTableViewController)
    
    _ = presenter
  }
  
  func connectControllerInteractor() {
    let hierarchicalInteractor: HierarchicalInteractor = /*...*/ self.hierarchicalInteractor
    let hierarchicalTableViewController: HierarchicalTableViewController = .init(tableView: UITableView())
    hierarchicalInteractor.connectController(hierarchicalTableViewController)
  }
  
}
