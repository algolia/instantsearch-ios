//
//  NumberRangeConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension NumberRangeConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: FilterState that holds your filters
     - attribute: Attribute to filter
     - bounds: Bounds limiting the max and the min value of the range
     - range: Initial range value
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
     - controller: Controller interfacing with a concrete number range view
  */
  convenience init<Controller: NumberRangeController>(searcher: HitsSearcher,
                                                      filterState: FilterState,
                                                      attribute: Attribute,
                                                      bounds: ClosedRange<Number>? = nil,
                                                      range: ClosedRange<Number>? = nil,
                                                      `operator`: RefinementOperator = .and,
                                                      groupName: String? = nil,
                                                      controller: Controller) where Controller.Number == Number {
    let interactor = NumberRangeInteractor(item: range)
    interactor.applyBounds(bounds: bounds)
    self.init(searcher: searcher,
              filterState: filterState,
              attribute: attribute,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
    connectController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete number range view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: NumberRangeController>(_ controller: Controller) -> NumberRange.ControllerConnection<Number, Controller> where Controller.Number == Number {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
