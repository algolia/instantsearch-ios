//
//  FilterClearConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that lets the user clear all filters that are currently active within the given FilterState
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/clear-refinements/ios/)
public class FilterClearConnector {

  /// FilterState that holds your filters
  public let filterState: FilterState

  /// Logic applied to Clear Filters
  public let interactor: FilterClearInteractor

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - filterState: FilterState that holds your filters
     - interactor: Logic applied to Clear Filters
     - clearMode: Whether we should clear the `specified` filters or all filters `except` them
     - filterGroupIDs: The groupIDs of filters to clear. All filters will be cleared if unspecified.
   */
  public init(filterState: FilterState,
              interactor: FilterClearInteractor = .init(),
              clearMode: ClearMode = .specified,
              filterGroupIDs: [FilterGroup.ID]? = nil) {
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               filterGroupIDs: filterGroupIDs,
                                                               clearMode: clearMode)
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .filterClear,
                                    parameters: [
                                      clearMode == .specified ? .none : .clearMode,
                                      filterGroupIDs == nil ? .none : .filterGroupIds
                                    ])
  }

}

extension FilterClearConnector: Connection {

  public func connect() {
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
