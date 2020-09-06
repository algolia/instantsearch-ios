//
//  CurrentFiltersConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that display the current refinements and let users remove them.
public class CurrentFiltersConnector {

  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// When specified, only display current refinements matching these filter group ids
  public let groupIDs: Set<FilterGroup.ID>?
  
  /// The logic applied to the current filters
  public let interactor: CurrentFiltersInteractor

  /// Connection between interactor and filter state
  public let filterStateConnection: Connection

  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - groupIDs: When specified, only display current refinements matching these filter group ids
     - interactor: The logic applied to the current filters
  */
  public init(filterState: FilterState,
              groupIDs: Set<FilterGroup.ID>? = nil,
              interactor: CurrentFiltersInteractor = .init()) {
    self.filterState = filterState
    self.groupIDs = groupIDs
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState, filterGroupIDs: groupIDs)
  }

}

extension CurrentFiltersConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }
  
}
