//
//  ToggleFilterConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class ToggleFilterConnector<Filter: FilterType>: Connection {

  public let filterState: FilterState
  public let filter: Filter
  public let interactor: SelectableInteractor<Filter>

  public let filterStateConnection: Connection

  public init(filterState: FilterState,
              filter: Filter,
              isSelected: Bool,
              refinementOperator: RefinementOperator = .and,
              groupName: String? = nil) {
    self.filterState = filterState
    self.filter = filter
    self.interactor = SelectableInteractor(item: filter)
    self.interactor.isSelected = isSelected
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               operator: refinementOperator,
                                                               groupName: groupName ?? filter.attribute.rawValue)
  }

  public func connect() {
    filterStateConnection.connect()
  }

  public func disconnect() {
    filterStateConnection.disconnect()
  }

}
