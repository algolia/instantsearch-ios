//
//  SmartSortConnector.swift
//  
//
//  Created by Vladislav Fitc on 17/02/2021.
//

import Foundation

public class SmartSortConnector {

  /// Searcher that handles your searches
  public let searcher: Searcher

  /// Smart sort priority toggling logic
  public let interactor: SmartSortInteractor

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  internal init(searcher: Searcher,
                searcherConnection: Connection,
                interactor: SmartSortInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = searcherConnection
    self.controllerConnections = []
  }

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Smart sort priority toggling logic
   */
  public convenience init(searcher: SingleIndexSearcher,
                          interactor: SmartSortInteractor = .init()) {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
  }

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - queryIndex: Index of query to alter by smart sort toggling
      - interactor: Smart sort priority toggling logic
   */
  public convenience init(searcher: MultiIndexSearcher,
                          queryIndex: Int,
                          interactor: SmartSortInteractor = .init()) {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
  }

}

extension SmartSortConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
