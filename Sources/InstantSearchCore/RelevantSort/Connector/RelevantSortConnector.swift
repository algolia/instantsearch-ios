//
//  RelevantSortConnector.swift
//  
//
//  Created by Vladislav Fitc on 17/02/2021.
//

import Foundation

public class RelevantSortConnector {

  /// Searcher that handles your searches
  public let searcher: Searcher

  /// Relevant sort priority toggling logic
  public let interactor: RelevantSortInteractor

  /// Connection between interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  internal init(searcher: Searcher,
                searcherConnection: Connection,
                interactor: RelevantSortInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = searcherConnection
    self.controllerConnections = []
  }

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Relevant sort priority toggling logic
   */
  public convenience init(searcher: HitsSearcher,
                          interactor: RelevantSortInteractor = .init()) {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
  }

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - queryIndex: Index of query to alter by relevant sort toggling
      - interactor: Relevant sort priority toggling logic
   */
  public convenience init(searcher: MultiIndexSearcher,
                          queryIndex: Int,
                          interactor: RelevantSortInteractor = .init()) {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
  }

}

extension RelevantSortConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
