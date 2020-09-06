//
//  HierarchicalConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class HierarchicalConnector: Connection {

  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Current state of the filters.
  public let filterState: FilterState
  
  /// Logic applied to the hierarchical facets.
  public let interactor: HierarchicalInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection
  
  /// Connection between filter state and interactor
  public let filterStateConnection: Connection

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state that will hold your filters.
     - hierarchicalAttributes: The names of the hierarchical attributes that we need to target, in ascending order.
     - separator: The string separating the facets in the hierarchical facets.
  */
  public init(searcher: SingleIndexSearcher,
              filterState: FilterState,
              hierarchicalAttributes: [Attribute],
              separator: String) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = HierarchicalInteractor(hierarchicalAttributes: hierarchicalAttributes, separator: separator)
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
    self.filterStateConnection = interactor.connectFilterState(filterState)
  }

  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
  }

}
