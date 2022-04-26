//
//  SegmentedFilterDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 08.04.2022.
//

import Foundation
import InstantSearch

class SegmentedFilterDemoController {

  let searcher: HitsSearcher
  let filterState: FilterState
  let selectableFilterConnector: SelectableFilterConnector<Filter.Facet>
  let clearFilterConnector: FilterClearConnector
  
  init() {
    let gender: Attribute = "gender"
    let male = Filter.Facet(attribute: "gender", stringValue: "male")
    let female = Filter.Facet(attribute: "gender", stringValue: "female")
    let notSpecified = Filter.Facet(attribute: "gender", stringValue: "not specified")
    
    self.searcher = HitsSearcher(client: .demo,
                                 indexName: "mobile_demo_filter_segment")
    let items: [Int: Filter.Facet] = [
      0: male,
      1: female,
      2: notSpecified,
    ]
    self.filterState = FilterState()
    self.clearFilterConnector = .init(filterState: filterState)
    self.selectableFilterConnector = .init(searcher: searcher,
                                           filterState: filterState,
                                           items: items,
                                           selected: 0,
                                           attribute: gender,
                                           operator: .or)
    
    searcher.search()
    searcher.connectFilterState(filterState)
    filterState.notify(.add(filter: male, toGroupWithID: .or(name: gender.rawValue, filterType: .facet)))
  }
  
}
