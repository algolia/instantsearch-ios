//
//  SearchBoxConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that performs a text-based query
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/search-box/ios/)
public class SearchBoxConnector {

  /// Searcher that handles your searches
  public let searcher: QuerySettable & Searchable

  /// Business logic that handles new search inputs
  public let interactor: SearchBoxInteractor

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
  public init<Searcher: AnyObject & Searchable & QuerySettable>(searcher: Searcher,
                                                                interactor: SearchBoxInteractor = .init(),
                                                                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher,
                                                         searchTriggeringMode: searchTriggeringMode)
    self.controllerConnections = []
    Telemetry.shared.traceConnector(type: .searchBox,
                                    parameters: [
                                      searchTriggeringMode == .searchAsYouType ? .none : .searchTriggeringMode
                                    ])
  }

}

extension SearchBoxConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}

@available(*, deprecated, renamed: "SearchBoxConnector")
public typealias QueryInputConnector = SearchBoxConnector
