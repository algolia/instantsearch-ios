//
//  ToggleFilterSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class ToggleFilterSnippets {
  
  let filterToggleConnector: FilterToggleConnector = .init(filterState: .init(), filter: "" as Filter.Tag)
  let filterToggleInteractor: SelectableInteractor<Filter.Tag> = .init(item: "" as Filter.Tag)
  
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()

    let filterToggleConnector = FilterToggleConnector(filterState: filterState,
                                                      filter: "on sale" as Filter.Tag)
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
    _ = filterToggleConnector
  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let filterState: FilterState = .init()
    let filter: Filter.Tag = "on sale"
    let onSaleFilterInteractor: SelectableInteractor<Filter.Tag> = .init(item: filter)
        
    searcher.connectFilterState(filterState)
    onSaleFilterInteractor.connectFilterState(filterState)
    
    searcher.search()
    
  }
  
  func connectControllerConnector() {
    let filterToggleConnector: FilterToggleConnector<Filter.Tag> = /*...*/ self.filterToggleConnector
    let filterToggleSwitchController: FilterSwitchController<Filter.Tag> = .init(switch: UISwitch())
    filterToggleConnector.interactor.connectController(filterToggleSwitchController)
  }
  
  func connectControllerInteractor() {
    let filterToggleInteractor: SelectableInteractor<Filter.Tag> = /*...*/ self.filterToggleInteractor
    let filterToggleSwitchController: FilterSwitchController<Filter.Tag> = .init(switch: UISwitch())
    filterToggleInteractor.connectController(filterToggleSwitchController)
  }
  
}
