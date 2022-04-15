//
//  FacetListPersistentSelectionDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 15/04/2022.
//

import Foundation
import InstantSearchCore

class FacetListPersistentSelectionDemoController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  
  let colorConnector: FacetListConnector
  let categoryConnector: FacetListConnector
  
  init() {
    searcher = .init(client: .demo,
                     indexName: "mobile_demo_facet_list")
    filterState = .init()
    colorConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "color",
                           selectionMode: .multiple,
                           operator: .or)
    categoryConnector = .init(searcher: searcher,
                              filterState: filterState,
                              attribute: "category",
                              selectionMode: .single,
                              operator: .or)
    setup()
  }
  
  private func setup() {
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
}
