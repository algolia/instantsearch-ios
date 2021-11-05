//
//  ToggleFilterSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && (os(iOS) || os(macOS))

import UIKit

class ToggleFilterSnippets {
    
  func widgetSnippet() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let filterState: FilterState = .init()
    let filterToggleSwitchController: FilterSwitchController<Filter.Tag> = .init(switch: UISwitch())

    let filterToggleConnector = FilterToggleConnector(filterState: filterState,
                                                      filter: "on sale" as Filter.Tag,
                                                      controller: filterToggleSwitchController)
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
    _ = filterToggleConnector
  }
  
  func advancedSnippet() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let filterState: FilterState = .init()
    let filter: Filter.Tag = "on sale"
    let filterToggleSwitchController: FilterSwitchController<Filter.Tag> = .init(switch: UISwitch())
    let onSaleFilterInteractor: SelectableInteractor<Filter.Tag> = .init(item: filter)
        
    searcher.connectFilterState(filterState)
    onSaleFilterInteractor.connectFilterState(filterState)
    onSaleFilterInteractor.connectController(filterToggleSwitchController)
    searcher.search()
    
  }
    
}
#endif
