//
//  FilterClearConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that clears all refinements that are currently active within the given FilterState
public class FilterClearConnector {
  
  /// Filter state that will hold your filters
  public let filterState: FilterState
  
  /// Logic applied to the clear control
  public let interactor: FilterClearInteractor
  
  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /**
   - Parameters:
     - filterState: Filter state that will hold your filters
     - interactor: Logic applied to the Clear Refinements
     - clearMode: Whether we should clear the specified filters or all filters except them
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
  }
  
}

extension FilterClearConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
  }
  
  public func disconnect() {
    filterStateConnection.disconnect()
  }
  
}
