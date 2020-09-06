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
  
  /// The logic applied to the hits
  public let interactor: HitsInteractor<Hit>
  
  /// Filter state that will hold your filters
  public let filterState: FilterState?

  /// Connection between hits interactor and filter state
  public let filterStateConnection: Connection?
  
  /// Connection between hits interactor and searcher
  public let searcherConnection: Connection

  internal init<S: Searcher>(searcher: S,
                             interactor: HitsInteractor<Hit>,
                             filterState: FilterState? = .none,
                             connectSearcher: (S) -> Connection) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = interactor
    self.filterStateConnection = filterState.flatMap(interactor.connectFilterState)
    self.searcherConnection = connectSearcher(searcher)
  }

}

extension HitsConnector: Connection {
  
  public func connect() {
    filterStateConnection?.connect()
    searcherConnection.connect()
  }

  public func disconnect() {
    filterStateConnection?.disconnect()
    searcherConnection.disconnect()
  }

}

public extension HitsConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - interactor: External hits interactor
     - filterState: Filter state that will hold your filters.
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
     - interactor: External hits interactor
     - filterState: Filter state that will hold your filters
  */
  convenience init(appID: ApplicationID,
                   apiKey: APIKey,
                   indexName: IndexName,
                   interactor: HitsInteractor<Hit> = .init(),
                   filterState: FilterState? = .none) {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
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
     - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
     - filterState: Filter state that will hold your filters
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

public typealias PlaceHit = Hit<Place>

public extension HitsConnector where Hit == PlaceHit {

  /**
   Convenient initializer for Places search
   - Parameters:
     - searcher: Places Searcher that handles your searches
     - interactor: External hits interactor
  */
  convenience init(searcher: PlacesSearcher,
                   interactor: HitsInteractor<Hit>) {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
  }

  /**
   Convenient initializer for Places search
   - Parameters:
     - placesAppID: Places Application ID
     - apiKey: Places API Key
     - interactor: External hits interactor
  */
  convenience init(placesAppID: ApplicationID,
                   apiKey: APIKey,
                   interactor: HitsInteractor<Hit>) {
    let searcher = PlacesSearcher(appID: placesAppID, apiKey: apiKey)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
  }
  
  /**
   Convenient initializer for Places search
   - Parameters:
     - placesAppID: Places Application ID
     - apiKey: Places API Key
     - infiniteScrolling: Infinite scrolling toggle
     - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
  */
  convenience init(placesAppID: ApplicationID,
                   apiKey: APIKey,
                   infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                   showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
    let searcher = PlacesSearcher(appID: placesAppID, apiKey: apiKey)
    let interactor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling, showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: nil,
              connectSearcher: interactor.connectPlacesSearcher)
  }

}
