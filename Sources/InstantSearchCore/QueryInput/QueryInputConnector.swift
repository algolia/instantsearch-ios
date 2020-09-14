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
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

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
    self.controllerConnections = []
  }

}

extension QueryInputConnector {
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Business logic that handles new search inputs
     - searchTriggeringMode: Defines the event triggering a new search
     - controller: Controller that interfaces with a concrete query input view
   */
  public convenience init<Controller: QueryInputController>(searcher: S,
              interactor: QueryInputInteractor = .init(),
              searchTriggeringMode: SearchTriggeringMode = .searchAsYouType,
              controller: Controller) {
    self.init(searcher: searcher,
              interactor: interactor,
              searchTriggeringMode: searchTriggeringMode)
    connectController(controller)
  }
  
  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller that interfaces with a concrete query input view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: QueryInputController>(_ controller: Controller) -> some Connection {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
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
