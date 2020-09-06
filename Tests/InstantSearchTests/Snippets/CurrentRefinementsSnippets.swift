//
//  CurrentRefinementsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class CurrentRefinementsSnippets {
  
  let currentFiltersConnector = CurrentFiltersConnector(filterState: .init())
  let currentFiltersInteractor = CurrentFiltersInteractor()
  
  func widgetSnippet() {
    let filterState = FilterState()
    let groupID: FilterGroup.ID = .and(name: "color")
    let currentFiltersConnector = CurrentFiltersConnector(filterState: filterState,
                                                          groupIDs: [groupID])
    _ = currentFiltersConnector
  }
  
  func advancedSnippet() {
    let filterState = FilterState()
    let groupID: FilterGroup.ID = .and(name: "color")
    let currentFiltersInteractor = CurrentFiltersInteractor()
    _ =
    currentFiltersInteractor.connectFilterState(filterState, filterGroupID: groupID)
  }
  
  func connectControllerConnector() {
    let currenfFiltersConnector: CurrentFiltersConnector = /*...*/ self.currentFiltersConnector
    let currenfFiltersTableController: CurrentFilterListTableController = .init(tableView: UITableView())
    currenfFiltersConnector.interactor.connectController(currenfFiltersTableController)
  }
  
  func connectControllerInteractor() {
    let currentFiltersInteractor: CurrentFiltersInteractor = /*...*/ self.currentFiltersInteractor
    let currentFiltersTableController: CurrentFilterListTableController = .init(tableView: UITableView())
    currentFiltersInteractor.connectController(currentFiltersTableController)
  }

  
}
