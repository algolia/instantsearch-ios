//
//  MultiIndexHitsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component thath manages and displays a paginated list of search results from multiple indices
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/multi-hits/ios/)
@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public class MultiIndexHitsConnector {

  /// Searcher that handles your searches
  public let searcher: MultiIndexSearcher

  /// Logic applied to the hits
  public let interactor: MultiIndexHitsInteractor

  /// List of FilterStates that will hold your filters separately for each index
  public let filterStates: [FilterState?]

  /// Connections between hits interactors and filter states
  public let filterStatesConnections: [Connection]

  /// Connection between hits interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: External hits interactor
     - filterState: List of FilterStates that will hold your filters separately for each index
  */
  public init(searcher: MultiIndexSearcher,
              interactor: MultiIndexHitsInteractor,
              filterStates: [FilterState?] = []) {
    self.searcher = searcher
    self.interactor = interactor
    self.filterStates = filterStates
    self.searcherConnection = interactor.connectSearcher(searcher)
    self.filterStatesConnections = zip(interactor.hitsInteractors, filterStates).compactMap { arg in
      let (interactor, filterState) = arg
      return filterState.flatMap(interactor.connectFilterState)
    }
    self.controllerConnections = []
  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
extension MultiIndexHitsConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    filterStatesConnections.forEach { $0.connect() }
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStatesConnections.forEach { $0.disconnect() }
    controllerConnections.forEach { $0.disconnect() }
  }

}

// MARK: - Convenient initializers
@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsConnector {

  /**
   - Parameters:
     - appID: ID of your application
     - apiKey: Your application API Key
     - indexModules: List of index modules representing the aggregaged indices
  */
  convenience init(appID: ApplicationID,
                   apiKey: APIKey,
                   indexModules: [IndexModule]) {
    let searcher = MultiIndexSearcher(appID: appID,
                                      apiKey: apiKey,
                                      indexNames: indexModules.map { $0.indexName })
    let interactor = MultiIndexHitsInteractor(hitsInteractors: indexModules.map { $0.hitsInteractor })
    self.init(searcher: searcher,
              interactor: interactor,
              filterStates: indexModules.map { $0.filterState })
  }

}
