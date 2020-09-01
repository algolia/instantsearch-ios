//
//  FilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FacetFilter = Filter.Facet
public typealias NumericFilter = Filter.Numeric
public typealias TagFilter = Filter.Tag

/// Components that display a list of filters.
public class FilterListConnector<Filter: FilterType & Hashable>: Connection {

  /// Filter state that will hold your filters.
  public let filterState: FilterState
  
  /// The logic applied to the filters
  public let interactor: FilterListInteractor<Filter>
  
  /// Connection between interactor and filter state
  public let connectionFilterState: Connection

  /// Initializer with external interactor
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter interactor: External filter list interactor
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Filter group name
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
