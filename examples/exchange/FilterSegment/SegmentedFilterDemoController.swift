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
  let segmentedFilterInteractor: SelectableSegmentInteractor<Int, Filter.Facet>
  
  init<SC: SelectableSegmentController>(segmentedController: SC) where SC.SegmentKey == Int {
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
    self.segmentedFilterInteractor = SelectableSegmentInteractor(items: items)
    
    searcher.search()
    searcher.connectFilterState(filterState)

    segmentedFilterInteractor.connectSearcher(searcher, attribute: gender)
    segmentedFilterInteractor.connectFilterState(filterState, attribute: gender, operator: .or)
    segmentedFilterInteractor.connectController(segmentedController)
    filterState.notify(.add(filter: male, toGroupWithID: .or(name: gender.rawValue, filterType: .facet)))
  }
  
}
