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
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to the stats
   */
  public init(searcher: SingleIndexSearcher,
              interactor: StatsInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    searcherConnection = interactor.connectSearcher(searcher)
    controllerConnections = []
  }

}

public extension StatsConnector {
  
  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to the stats
      - controller: Controller that interfaces with a concrete stats view
   */
  convenience init<Controller: StatsTextController>(searcher: SingleIndexSearcher,
                                               interactor: StatsInteractor = .init(),
                                               controller: Controller) {
    self.init(searcher: searcher,
              interactor: interactor)
    connectController(controller)
  }
  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller that interfaces with a concrete stats view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: StatsTextController>(_ controller: Controller) -> some Connection {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
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
