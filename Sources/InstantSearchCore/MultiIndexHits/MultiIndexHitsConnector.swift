//
//  MultiIndexHitsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that manages and displays a paginated list of search results from multiple indices.
public class MultiIndexHitsConnector {

  /// Searcher that handles your searches
  public let searcher: MultiIndexSearcher
  
  /// The logic applied to the hits
  public let interactor: MultiIndexHitsInteractor
  
  /// Filter states that will hold your filters respectively for each index
  public let filterStates: [FilterState?]
  
  /// Connections between hits interactors and filter states
  public let filterStatesConnections: [Connection]
  
  /// Connection between hits interactor and searcher
  public let searcherConnection: Connection

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: External hits interactor
     - filterState: Filter states that will hold your filters respectively for each index
  */
  public init(searcher: MultiIndexSearcher,
              interactor: MultiIndexHitsInteractor,
              filterStates: [FilterState?]) {
    self.searcher = searcher
    self.interactor = interactor
    self.filterStates = filterStates
    self.searcherConnection = interactor.connectSearcher(searcher)
    self.filterStatesConnections = zip(interactor.hitsInteractors, filterStates).compactMap { arg in
      let (interactor, filterState) = arg
      return filterState.flatMap(interactor.connectFilterState)
    }
  }


}

extension MultiIndexHitsConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    filterStatesConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStatesConnections.forEach { $0.disconnect() }
  }
  
}

public extension MultiIndexHitsConnector {

  /// Structure representing a single index search components within a multi-index experience
  struct IndexModule {

    /// Name of the index
    public let indexName: IndexName
    
    /// The logic applied to the hits
    public let hitsInteractor: AnyHitsInteractor
    
    /// Filter state that will hold the filters
    public let filterState: FilterState?

    /**
     - Parameters:
       - indexName: Name of the index
       - hitsInteractor: The logic applied to the hits
       - filterState: Filter state that will hold the filters
    */
    public init<Hit: Codable>(indexName: IndexName,
                              hitsInteractor: HitsInteractor<Hit>,
                              filterState: FilterState? = .none) {
      self.indexName = indexName
      self.hitsInteractor = hitsInteractor
      self.filterState = filterState
    }

    /**
     - Parameters:
       - indexName: Name of the index
       - hitsInteractor: Infinite scrolling toggle
       - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
       - filterState: Filter state that will hold the filters
    */
    public init(indexName: IndexName,
                infiniteScrolling: InfiniteScrolling = .on(withOffset: 10),
                showItemsOnEmptyQuery: Bool = true,
                filterState: FilterState? = .none) {
      let hitsInteractor = HitsInteractor<JSON>(infiniteScrolling: infiniteScrolling,
                                                showItemsOnEmptyQuery: showItemsOnEmptyQuery)
      self.init(indexName: indexName,
                hitsInteractor: hitsInteractor,
                filterState: filterState)
    }

  }

}

public extension MultiIndexHitsConnector.IndexModule {

  /**
   Convenient initializer constructing index module for suggestions index
   - Parameters:
     - suggestionsIndexName: Name of the index containing the search suggestions
     - hitsInteractor: The logic applied to the suggestions
     - filterState: Filter states that will hold suggesions filters
  */
  init(suggestionsIndexName: IndexName,
       hitsInteractor: HitsInteractor<Hit<QuerySuggestion>> = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true),
       filterState: FilterState? = .none) {
    self.init(indexName: suggestionsIndexName,
              hitsInteractor: hitsInteractor,
              filterState: filterState)
  }

}

public extension MultiIndexHitsConnector {
  
  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexModules: The list of index modules representing the aggregaged indices
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
 
