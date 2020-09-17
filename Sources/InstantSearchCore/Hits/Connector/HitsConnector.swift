//
//  HitsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that manages and displays a list of search results
public class HitsConnector<Hit: Codable> {

  /// Searcher that handles your searches
  public let searcher: Searcher
  
  /// Logic applied to the hits
  public let interactor: HitsInteractor<Hit>
  
  /// Filter state holding your filters
  public let filterState: FilterState?

  /// Connection between hits interactor and filter state
  public let filterStateConnection: Connection?
  
  /// Connection between hits interactor and searcher
  public let searcherConnection: Connection
  
  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  internal init<S: Searcher>(searcher: S,
                             interactor: HitsInteractor<Hit>,
                             filterState: FilterState? = .none,
                             connectSearcher: (S) -> Connection) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = filterState.flatMap(interactor.connectFilterState)
    self.searcherConnection = connectSearcher(searcher)
    self.controllerConnections = []
  }
  
  internal convenience init<S: Searcher, Controller: HitsController>(searcher: S,
                                                                     interactor: HitsInteractor<Hit>,
                                                                     filterState: FilterState? = .none,
                                                                     connectSearcher: (S) -> Connection,
                                                                     controller: Controller,
                                                                     externalReload: Bool = false) where Controller.DataSource == HitsInteractor<Hit> {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: connectSearcher)
    connectController(controller, externalReload: externalReload)
  }
  
}

extension HitsConnector: Connection {
  
  public func connect() {
    filterStateConnection?.connect()
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    filterStateConnection?.disconnect()
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}

//MARK: - Convenient initializers

public extension HitsConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - interactor: External hits interactor
     - filterState: Filter state holding your filters
  */
  convenience init(searcher: SingleIndexSearcher,
                   interactor: HitsInteractor<Hit> = .init(),
                   filterState: FilterState? = .none) {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher)
  }
  
  /**
   - Parameters:
     - appID: Application ID
     - apiKey: API Key
     - indexName: Name of the index in which search will be performed
     - infiniteScrolling: Infinite scrolling toggle
     - showItemsOnEmptyQuery: Defines if interactor gives access to the hits in case of empty query
     - filterState: Filter state holding your filters
  */
  convenience init(appID: ApplicationID,
                   apiKey: APIKey,
                   indexName: IndexName,
                   infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                   showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery,
                   filterState: FilterState? = .none) {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling, showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher)
  }

}
