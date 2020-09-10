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
public class FilterListConnector<Filter: FilterType & Hashable> {

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
  
  /// Initializer with external interactor
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter filters: List of filters to display
  /// - Parameter selectionMode: Whether the list can have single or multiple selections
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Filter group name
  public convenience init(filterState: FilterState,
                          filters: [Filter],
                          selectionMode: SelectionMode,
                          `operator`: RefinementOperator,
                          groupName: String) {
    let interactor = FilterListInteractor<Filter>.init(items: filters,
                                                       selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
}

extension FilterListConnector: Connection {
  
  public func connect() {
    connectionFilterState.connect()
  }

  public func disconnect() {
    connectionFilterState.disconnect()
  }
  
}
