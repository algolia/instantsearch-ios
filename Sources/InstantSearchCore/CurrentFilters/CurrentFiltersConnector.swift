//
//  CurrentFiltersConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class CurrentFiltersConnector: Connection {

  public let filterState: FilterState
  public let groupIDs: Set<FilterGroup.ID>?
  public let interactor: CurrentFiltersInteractor

  public let filterStateConnection: Connection

  public init(filterState: FilterState,
              groupIDs: Set<FilterGroup.ID>? = nil,
              interactor: CurrentFiltersInteractor = .init()) {
    self.filterState = filterState
    self.groupIDs = groupIDs
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState, filterGroupIDs: groupIDs)

  }

  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }

}
