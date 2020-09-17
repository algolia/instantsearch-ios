//
//  HierarchicalConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class HierarchicalConnector {

  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Filter state holding your filters
  public let filterState: FilterState
  
  /// Logic applied to the hierarchical facets.
  public let interactor: HierarchicalInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection
  
  /// Connection between filter state and interactor
  public let filterStateConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: Filter state holding your filters
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
    self.controllerConnections = []
  }

}

extension HierarchicalConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }
  
}
