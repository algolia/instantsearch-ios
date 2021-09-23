//
//  CurrentRefinementsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class CurrentRefinementsSnippets {
  
  func widgetSnippet() {
    let filterState = FilterState()
    let groupID: FilterGroup.ID = .and(name: "color")
    let currenfFiltersTableController: CurrentFilterListTableController = .init(tableView: UITableView())
    let currentFiltersConnector = CurrentFiltersConnector(filterState: filterState,
                                                          groupIDs: [groupID],
                                                          controller: currenfFiltersTableController)
    _ = currentFiltersConnector
  }
  
  func advancedSnippet() {
    let filterState = FilterState()
    let groupID: FilterGroup.ID = .and(name: "color")
    let currentFiltersTableController: CurrentFilterListTableController = .init(tableView: UITableView())
    let currentFiltersInteractor = CurrentFiltersInteractor()
    currentFiltersInteractor.connectFilterState(filterState, filterGroupID: groupID)
    currentFiltersInteractor.connectController(currentFiltersTableController)
  }

}
#endif
