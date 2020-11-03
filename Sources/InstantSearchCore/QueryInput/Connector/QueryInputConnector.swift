//
//  QueryInputConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that performs a text-based query
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/search-box/ios/)
public class QueryInputConnector {

  /// Searcher that handles your searches
  public let searcher: Searcher

  /// Business logic that handles new search inputs
  public let interactor: QueryInputInteractor

  /// Connection between query input interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Business logic that handles new search inputs
     - searchTriggeringMode: Defines the event triggering a new search
   */
  public init<S: Searcher>(searcher: S,
                           interactor: QueryInputInteractor = .init(),
                           searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher, searchTriggeringMode: searchTriggeringMode)
    self.controllerConnections = []
  }

}

extension QueryInputConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
