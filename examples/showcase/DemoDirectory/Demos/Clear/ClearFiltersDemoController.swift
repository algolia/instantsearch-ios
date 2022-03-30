//
//  ClearFiltersDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class ClearFiltersDemoController {
  
  let filterState: FilterState

  let clearColorsConnector: FilterClearConnector
  let clearExceptColorsConnector: FilterClearConnector
  
  init<FCC: FilterClearController>(clearController: FCC,
                                   clearExceptController: FCC) {
    filterState = .init()
    let groupColor = FilterGroup.ID.or(name: "color", filterType: .facet)
    clearColorsConnector = .init(filterState: filterState,
                                 clearMode: .specified,
                                 filterGroupIDs: [groupColor],
                                 controller: clearController)
    clearExceptColorsConnector = .init(filterState: filterState,
                                       clearMode: .except,
                                       filterGroupIDs: [groupColor],
                                       controller: clearExceptController)
    
    let categoryFacet = Filter.Facet(attribute: "category", value: "shoe")
    let redFacet = Filter.Facet(attribute: "color", value: "red")
    let greenFacet = Filter.Facet(attribute: "color", value: "green")
    
    filterState[and: "category"].add(categoryFacet)
    filterState[or: "color"].add(redFacet, greenFacet)
    filterState.notifyChange()
  }
  
}
