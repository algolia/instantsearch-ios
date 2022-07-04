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

  /// Searcher that handles your searches
  public let searcher: Searcher

  /// Logic applied to comparison
  public let interactor: NumberInteractor<Number>

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Attribute to filter with a numeric comparison
  public let attribute: Attribute

  /// Comparison operator to apply
  public let numericOperator: Filter.Numeric.Operator

  /// Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state
  public let `operator`: RefinementOperator

  /// Filter group name in the filter state
  public let groupName: String

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - filterState: FilterState that holds your filters
     - attribute: Attribute to filter with a numeric comparison
     - numericOperator: Comparison operator to apply
     - number: Initial numeric value to filter on.
     - bounds: Optional bounds limiting the max and the min value of the number
     - operator: Whether the filter is added to a conjuncitve(`and`) or  a disjuncitve (`or`) group in the filter state. Default value: .and
     - groupName: Filter group name in the filter state. If not specified, the attribute value is used as the group name
  */
  public init(searcher: HitsSearcher,
              filterState: FilterState,
              attribute: Attribute,
              numericOperator: Filter.Numeric.Operator,
              number: Number? = nil,
              bounds: ClosedRange<Number>? = nil,
              operator: RefinementOperator = .and,
              groupName: String? = nil) {
    self.searcher = searcher
    self.interactor = .init()
    self.filterState = filterState
    self.attribute = attribute
    self.numericOperator = numericOperator
    self.operator = `operator`
    self.groupName = groupName ?? attribute.rawValue
    self.searcherConnection = interactor.connectSearcher(searcher, attribute: attribute)
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               attribute: attribute,
                                                               numericOperator: numericOperator,
                                                               operator: `operator`,
                                                               groupName: groupName)
    if let number = number {
      self.interactor.computeNumber(number: number)
    }
    if let bounds = bounds {
      self.interactor.applyBounds(bounds: bounds)
    }
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .numberFilter,
                                    parameters: [
                                      bounds == nil ? .none : .bounds,
                                      groupName == nil ? .none : .groupName
                                    ])
  }

}

extension FilterComparisonConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.connect()
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
