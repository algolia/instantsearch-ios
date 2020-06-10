//
//  FilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FilterListConnector<Filter: FilterType & Hashable>: Connection {

  public let filterState: FilterState
  public let interactor: FilterListInteractor<Filter>
  public let connectionFilterState: Connection

  public init(filterState: FilterState,
              interactor: FilterListInteractor<Filter>,
              `operator`: RefinementOperator,
              groupName: String) {
    self.filterState = filterState
    self.interactor = interactor
    self.connectionFilterState = interactor.connectFilterState(filterState,
                                                               operator: `operator`,
                                                               groupName: groupName)
  }

  public func connect() {
    connectionFilterState.connect()
  }

  public func disconnect() {
    connectionFilterState.disconnect()
  }

}
