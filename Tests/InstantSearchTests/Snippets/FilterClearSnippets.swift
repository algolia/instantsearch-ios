//
//  FilterClearSnippets.swift
//  
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class FilterClearSnippets {
  
  func widgetSnippet() {
    let filterState: FilterState = .init()
    let clearRefinementsController: FilterClearButtonController = .init(button: UIButton())

    let filterClearConnector: FilterClearConnector = .init(filterState: filterState,
                                                           clearMode: .specified,
                                                           filterGroupIDs: [.and(name: "color"), .or(name: "category",
                                                                                                     filterType: .facet)],
                                                           controller: clearRefinementsController)
    _ = filterClearConnector
  }
  
  func advancedSnippet() {
    let filterState: FilterState = .init()
    let filterClearInteractor: FilterClearInteractor = .init()
    let clearRefinementsController: FilterClearButtonController = .init(button: UIButton())

    filterClearInteractor.connectFilterState(filterState,
                                             filterGroupIDs: [
                                              .and(name: "color"),
                                              .or(name: "category", filterType: .facet)
                                             ],
                                             clearMode: .specified)
    filterClearInteractor.connectController(clearRefinementsController)
  }
    
}
#endif
