//
//  FilterToggleConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Filtering component that displays any kind of filter, and lets the user refine the search results by toggling it on or off.
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/toggle-refinement/ios/)
public class FilterToggleConnector<Filter: FilterType> {

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to Filter Toggle
  public let interactor: SelectableInteractor<Filter>

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - interactor: Logic applied to Filter Toggle
     - operator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state.
     - groupName: Filter group name in the filter state. If not specified
   */
  public init(filterState: FilterState,
              interactor: SelectableInteractor<Filter>,
              operator: RefinementOperator = .and,
              groupName: String? = nil) {
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               operator: `operator`,
                                                               groupName: groupName ?? interactor.item.attribute.rawValue)
    controllerConnections = []
    Telemetry.shared.traceConnector(type: .filterToggle,
                                    parameters: [
                                      `operator` == .and ? .none : .operator,
                                      groupName == nil ? .none : .groupName
                                    ])
  }

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - filter: Filter to toggle
     - isSelected: Whether the filter is initially selected
     - operator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state.
     - groupName: Filter group name in the filter state.
   */
  public convenience init(filterState: FilterState,
                          filter: Filter,
                          isSelected: Bool = false,
                          operator: RefinementOperator = .and,
                          groupName: String? = nil) {
    let interactor = SelectableInteractor(item: filter)
    interactor.isSelected = isSelected
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
    Telemetry.shared.traceConnector(type: .filterToggle,
                                    parameters: [
                                      isSelected ? .isSelected : .none,
                                      `operator` == .and ? .none : .operator,
                                      groupName == nil ? .none : .groupName
                                    ])
  }

}

extension FilterToggleConnector: Connection {

  public func connect() {
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
