//
//  FilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Components that display a list of filters.
public class FilterListConnector<Filter: FilterType & Hashable> {

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to the filters
  public let interactor: FilterListInteractor<Filter>

  /// Connection between interactor and filter state
  public let connectionFilterState: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
  Init with explicit interactor
  - Parameters:
    - filterState: FilterState that holds your filters
    - interactor: External filter list interactor
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
  */
  public init(filterState: FilterState,
              interactor: FilterListInteractor<Filter>,
              `operator`: RefinementOperator,
              groupName: String) {
    self.filterState = filterState
    self.interactor = interactor
    self.connectionFilterState = interactor.connectFilterState(filterState,
                                                               operator: `operator`,
                                                               groupName: groupName)
    self.controllerConnections = []
  }

  /**
  Init with implicit interactor
  - Parameters:
    - filterState: FilterState that holds your filters
    - filters: List of filters to display
    - selectionMode: Whether the list can have single or multiple selections
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
  */
  public convenience init(filterState: FilterState,
                          filters: [Filter],
                          selectionMode: SelectionMode,
                          `operator`: RefinementOperator,
                          groupName: String) {
    let interactor = FilterListInteractor<Filter>.init(items: filters,
                                                       selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }

}

extension FilterListConnector: Connection {

  public func connect() {
    connectionFilterState.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    connectionFilterState.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
