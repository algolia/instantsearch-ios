//
//  QueryInputConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that performs a text-based query
public class QueryInputConnector<S: Searcher> {

  /// Searcher that handles your searches
  public let searcher: S
  
  /// Business logic that handles new search inputs
  public let interactor: QueryInputInteractor

  /// Connection between query input interactor and searcher
  public let searcherConnection: Connection

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Business logic that handles new search inputs
     - searchTriggeringMode: Defines the event triggering a new search
   */
  public init(searcher: S,
              interactor: QueryInputInteractor = .init(),
              searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher, searchTriggeringMode: searchTriggeringMode)
  }

}

extension QueryInputConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }
  
}
