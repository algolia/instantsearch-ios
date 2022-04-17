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
  
  init() {
    numberInteractor = NumberInteractor<Double>()
    filterState = FilterState()
    numberInteractor.connectFilterState(filterState,
                                        attribute: "rating",
                                        numericOperator: .greaterThanOrEqual)
  }
  
}
