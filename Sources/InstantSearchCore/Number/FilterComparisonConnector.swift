//
//  FilterComparisonConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component to filter on a numeric value using a comparison operator.
public class FilterComparisonConnector<Number: Comparable & DoubleRepresentable> {

  /// Logic applied to comparison
  public let interactor: NumberInteractor<Number>
  
  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// Attribute to filter with a numeric comparison
  public let attribute: Attribute
  
  /// Comparison operator to apply
  public let numericOperator: Filter.Numeric.Operator
  
  /// Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state
  public let `operator`: RefinementOperator
  
  /// Filter group name in the filter state
  public let groupName: String

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - attribute: Attribute to filter with a numeric comparison
     - numericOperator: Comparison operator to apply
     - number: Initial number value
     - bounds: Optional bounds limiting the max and the min value of the number
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
  */
  public init(filterState: FilterState,
              attribute: Attribute,
              numericOperator: Filter.Numeric.Operator,
              number: Number,
              bounds: ClosedRange<Number>?,
              operator: RefinementOperator,
              groupName: String? = nil) {
    self.interactor = .init()
    self.filterState = filterState
    self.attribute = attribute
    self.numericOperator = numericOperator
    self.operator = `operator`
    self.groupName = groupName ?? attribute.rawValue
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               attribute: attribute,
                                                               numericOperator: numericOperator,
                                                               operator: `operator`,
                                                               groupName: groupName)
    self.interactor.computeNumber(number: number)
    if let bounds = bounds {
      self.interactor.applyBounds(bounds: bounds)
    }
    self.controllerConnections = []
  }

}

//MARK: - Controller initializing and connectivity

public extension FilterComparisonConnector {
  
  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - attribute: Attribute to filter with a numeric comparison
     - numericOperator: Comparison operator to apply
     - number: Initial number value
     - bounds: Optional bounds limiting the max and the min value of the number
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
     - controller: Controller that interfaces with a concrete number view
  */
  convenience init<Controller: NumberController>(filterState: FilterState,
                                                 attribute: Attribute,
                                                 numericOperator: Filter.Numeric.Operator,
                                                 number: Number,
                                                 bounds: ClosedRange<Number>?,
                                                 operator: RefinementOperator,
                                                 groupName: String? = nil,
                                                 controller: Controller) where Controller.Item == Number {
    self.init(filterState: filterState,
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
     - controller: Controller that interfaces with a concrete number view
   - Returns: Established connection
  */
  @discardableResult func connectNumberController<Controller: NumberController>(_ controller: Controller) -> some Connection where Controller.Item == Number {
    let connection = interactor.connectNumberController(controller)
    controllerConnections.append(connection)
    return connection
  }

  
}

extension FilterComparisonConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }
  
}
