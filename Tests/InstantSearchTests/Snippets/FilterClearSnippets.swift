//
//  FilterClearSnippets.swift
//  
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class FilterClearSnippets {
  
  let filterClearConnector = FilterClearConnector(filterState: .init())
  let filterClearInteractor = FilterClearInteractor()

  func widgetSnippet() {
    let filterState: FilterState = .init()
    
    let filterClearConnector: FilterClearConnector = .init(filterState: filterState,
                                                           clearMode: .specified,
                                                           filterGroupIDs: [.and(name: "color"), .or(name: "category",
                                                                                                     filterType: .facet)])
    _ = filterClearConnector
  }
  
  func advancedSnippet() {
    let filterState: FilterState = .init()
    let filterClearInteractor: FilterClearInteractor = .init()

    filterClearInteractor.connectFilterState(filterState,
                                             filterGroupIDs: [
                                              .and(name: "color"),
                                              .or(name: "category", filterType: .facet)
                                             ],
                                             clearMode: .specified)
  }
  
  func connectControllerConnector() {
    let filterClearConnector: FilterClearConnector = /*...*/ self.filterClearConnector
    let clearRefinementsController: FilterClearButtonController = .init(button: UIButton())
    filterClearConnector.interactor.connectController(clearRefinementsController)
  }
  
  func connectControllerInteractor() {
    let filterClearInteractor: FilterClearInteractor = /*...*/self.filterClearInteractor
    let clearRefinementsController: FilterClearButtonController = .init(button: UIButton())
    filterClearInteractor.connectController(clearRefinementsController)
  }
  
}
