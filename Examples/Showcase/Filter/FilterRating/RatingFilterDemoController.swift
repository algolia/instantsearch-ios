//
//  RatingFilterDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/04/2022.
//

import Foundation
import InstantSearchCore

class RatingFilterDemoController {

  let filterState: FilterState
  let numberInteractor: NumberInteractor<Double>
  let clearFilterConnector: FilterClearConnector

  init() {
    numberInteractor = NumberInteractor<Double>()
    filterState = FilterState()
    clearFilterConnector = .init(filterState: filterState)
    numberInteractor.connectFilterState(filterState,
                                        attribute: "rating",
                                        numericOperator: .greaterThanOrEqual)
    filterState.notify(.add(filter: Filter.Numeric(attribute: "rating", operator: .greaterThanOrEqual, value: 3.5), toGroupWithID: .and(name: "rating")))
  }

}
