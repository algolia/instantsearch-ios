//
//  FilterToggleConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that toggles an arbitrary filter on or off
public class FilterToggleConnector<Filter: FilterType> {
  
  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// Logic applied to Filter Toggle
  public let interactor: SelectableInteractor<Filter>
  
  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - interactor: Logic applied to Filter Toggle
     - refinementOperator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state.
     - groupName: Filter group name in the filter state. If not specified
   */
  public init(filterState: FilterState,
              interactor: SelectableInteractor<Filter>,
              refinementOperator: RefinementOperator = .and,
              groupName: String? = nil) {
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               operator: refinementOperator,
                                                               groupName: groupName ?? interactor.item.attribute.rawValue)
  }
  
  /**
   - Parameters:
     - filterState: Filter state holding your filters
     - filter: Filter to toggle
     - isSelected: Whether the filter is initially selected
     - refinementOperator: Whether the filter is added to a conjuncitve(`and`) or a disjuncitve (`or`) group in the filter state.
     - groupName: Filter group name in the filter state.
   */
  public convenience init(filterState: FilterState,
                          filter: Filter,
                          isSelected: Bool = false,
                          refinementOperator: RefinementOperator = .and,
                          groupName: String? = nil) {
    let interactor = SelectableInteractor(item: filter)
    interactor.isSelected = isSelected
    self.init(filterState: filterState,
              interactor: interactor,
              refinementOperator: refinementOperator,
              groupName: groupName)
  }
  
}

extension FilterToggleConnector: Connection {
  
  public func connect() {
    filterStateConnection.connect()
  }
  
  public func disconnect() {
    filterStateConnection.disconnect()
  }
  
}

