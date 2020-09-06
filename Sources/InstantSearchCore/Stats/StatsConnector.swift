//
//  StatsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that displays metadata about the current search and its results.
public class StatsConnector {

  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Logic applied to the stats
  public let interactor: StatsInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection

  /**
    - Parameters:
      - searcher:
      - interactor:
   */
  public init(searcher: SingleIndexSearcher,
              interactor: StatsInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    searcherConnection = interactor.connectSearcher(searcher)
  }

}

extension StatsConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }
  
}
