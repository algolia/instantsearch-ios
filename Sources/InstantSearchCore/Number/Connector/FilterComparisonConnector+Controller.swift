//
//  FilterComparisonConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension FilterComparisonConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - filterState: FilterState that holds your filters
     - attribute: Attribute to filter with a numeric comparison
     - numericOperator: Comparison operator to apply
     - number: Initial number value
     - bounds: Optional bounds limiting the max and the min value of the number
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
     - controller: Controller interfacing with a concrete number view
  */
  convenience init<Controller: NumberController>(searcher: HitsSearcher,
                                                 filterState: FilterState,
                                                 attribute: Attribute,
                                                 numericOperator: Filter.Numeric.Operator,
                                                 number: Number,
                                                 bounds: ClosedRange<Number>?,
                                                 operator: RefinementOperator,
                                                 groupName: String? = nil,
                                                 controller: Controller) where Controller.Item == Number {
    self.init(searcher: searcher,
              filterState: filterState,
              attribute: attribute,
              numericOperator: numericOperator,
              number: number,
              bounds: bounds,
              operator: `operator`,
              groupName: groupName)
    connectNumberController(controller)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete number view
   - Returns: Established connection
  */
  @discardableResult func connectNumberController<Controller: NumberController>(_ controller: Controller) -> NumberInteractorControllerConnection<Controller, Number> where Controller.Item == Number {
    let connection = interactor.connectNumberController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
