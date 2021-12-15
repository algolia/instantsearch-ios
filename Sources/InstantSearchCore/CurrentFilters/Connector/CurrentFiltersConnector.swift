//
//  CurrentFiltersConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that shows the currently active filters within a given FilterState and lets users remove filters individually
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/current-refinements/ios/)
public class CurrentFiltersConnector {

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// When specified, only display current filters matching these filter group ids
  public let groupIDs: Set<FilterGroup.ID>?

  /// Logic applied to the current filters
  public let interactor: CurrentFiltersInteractor

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - groupIDs: When specified, only display current refinements matching these filter group ids
     - interactor: Logic applied to the current filters
  */
  public init(filterState: FilterState,
              groupIDs: Set<FilterGroup.ID>? = nil,
              interactor: CurrentFiltersInteractor = .init()) {
    self.filterState = filterState
    self.groupIDs = groupIDs
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState, filterGroupIDs: groupIDs)
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .currentFilters,
                                    parameters: [
                                      groupIDs?.isEmpty ?? true ? .none : .groupIds
                                    ])
  }

}

extension CurrentFiltersConnector: Connection {

  public func connect() {
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
