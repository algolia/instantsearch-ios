//
//  MultiIndexHitsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class MultiIndexHitsConnector: Connection {

  public let searcher: MultiIndexSearcher
  public let interactor: MultiIndexHitsInteractor
  public let filterStates: [FilterState?]
  public let filterStatesConnections: [Connection]
  public let searcherConnection: Connection

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

  struct IndexModule {

    public let indexName: IndexName
    public let hitsInteractor: AnyHitsInteractor
    public let filterState: FilterState?

    public init<Hit: Codable>(indexName: IndexName,
                              hitsInteractor: HitsInteractor<Hit>,
                              filterState: FilterState? = .none) {
      self.indexName = indexName
      self.hitsInteractor = hitsInteractor
      self.filterState = filterState
    }

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

public extension MultiIndexHitsConnector.IndexModule {

  init(suggestionsIndexName: IndexName,
       hitsInteractor: HitsInteractor<Hit<QuerySuggestion>> = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true),
       filterState: FilterState? = .none) {
    self.init(indexName: suggestionsIndexName,
              hitsInteractor: hitsInteractor,
              filterState: filterState)
  }

}
