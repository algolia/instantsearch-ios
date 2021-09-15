//
//  SwitchIndexConnector.swift
//  
//
//  Created by Vladislav Fitc on 12/09/2021.
//

import Foundation

/// Component that handles switching between the provided indices names
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/sort-by/ios/)
public class SwitchIndexConnector {
  
  /// Searcher that handles your searches
  public let searcher: AnyObject & Searchable & IndexNameSettable
  
  /// Business logic that handles index name switching
  public let interactor: SwitchIndexInteractor
  
  /// Connection between query input interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Business logic that handles  index name switching
     - searchTriggeringMode: Defines the event triggering a new search
   */
  public init<Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                    interactor: SwitchIndexInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher)
    self.controllerConnections = []
  }
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of names of available indices
     - selectedIndexName: Name of the currently selected index
   */
  public convenience init<Searcher: AnyObject & Searchable & IndexNameSettable>(searcher: Searcher,
                                                                                indexNames: [IndexName],
                                                                                selectedIndexName: IndexName) {
    let interactor = SwitchIndexInteractor(indexNames: indexNames,
                                           selectedIndexName: selectedIndexName)
    self.init(searcher: searcher,
              interactor: interactor)
  }
  
}

extension SwitchIndexConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
