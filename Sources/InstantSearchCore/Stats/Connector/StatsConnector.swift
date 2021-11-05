//
//  StatsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that displays metadata about the current search and its results.
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/stats/ios/)
public class StatsConnector {

  /// Searcher that handles your searches
  public let searcher: HitsSearcher

  /// Logic applied to Stats
  public let interactor: StatsInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to the stats
   */
  public init(searcher: HitsSearcher,
              interactor: StatsInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    searcherConnection = interactor.connectSearcher(searcher)
    controllerConnections = []
  }

}

extension StatsConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
