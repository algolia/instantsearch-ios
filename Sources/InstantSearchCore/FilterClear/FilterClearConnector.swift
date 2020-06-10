//
//  FilterClearConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterClearConnector: Connection {

  public let filterState: FilterState
  public let interactor: FilterClearInteractor
  public let filterStateConnection: Connection

  init(filterState: FilterState,
       interactor: FilterClearInteractor = .init(),
       clearMode: ClearMode = .specified,
       filterGroupIDs: [FilterGroup.ID]? = nil) {
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               filterGroupIDs: filterGroupIDs,
                                                               clearMode: clearMode)
  }

  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }

}
