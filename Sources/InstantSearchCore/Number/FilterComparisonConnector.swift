//
//  FilterComparisonConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterComparisonConnector<Number: Comparable & DoubleRepresentable>: Connection {

  public let interactor: NumberInteractor<Number>
  public let filterState: FilterState
  public let attribute: Attribute
  public let numericOperator: Filter.Numeric.Operator
  public let `operator`: RefinementOperator
  public let groupName: String

  public let filterStateConnection: Connection

  public init(interactor: NumberInteractor<Number>,
              filterState: FilterState,
              attribute: Attribute,
              numericOperator: Filter.Numeric.Operator,
              number: Number,
              operator: RefinementOperator,
              groupName: String? = nil) {
    self.interactor = interactor
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
  }

  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }

}
