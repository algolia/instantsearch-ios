//
//  LoadingConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that shows a loading indicator during pending requests.
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/loading/ios/)
public class LoadingConnector {

  /// Searcher that handles your searches
  public let searcher: Searcher

  /// Logic that handles showing a loading indicator
  public let interactor: LoadingInteractor

  /// Connection between searcher and interactor
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to a loading indicator
   */
  public init(searcher: Searcher,
              interactor: LoadingInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher)
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .loading)
  }

}

extension LoadingConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
