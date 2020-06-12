//
//  HitsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class HitsConnector<Hit: Codable>: Connection {

  public let searcher: Searcher
  public let interactor: HitsInteractor<Hit>
  public let filterState: FilterState?

  public let filterStateConnection: Connection?
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

  convenience init(searcher: SingleIndexSearcher,
                   interactor: HitsInteractor<Hit>,
                   filterState: FilterState? = .none) {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher)
  }

  convenience init(appID: ApplicationID,
                   apiKey: APIKey,
                   indexName: IndexName,
                   interactor: HitsInteractor<Hit>,
                   filterState: FilterState? = .none) {
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectSearcher)
  }

}

public typealias PlaceHit = Hit<Place>

public extension HitsConnector where Hit == PlaceHit {

  convenience init(searcher: PlacesSearcher,
                   interactor: HitsInteractor<Hit>,
                   filterState: FilterState? = .none) {
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectPlacesSearcher)
  }

  convenience init(placesAppID: ApplicationID,
                   apiKey: APIKey,
                   interactor: HitsInteractor<Hit>,
                   filterState: FilterState? = .none) {
    let searcher = PlacesSearcher(appID: placesAppID, apiKey: apiKey)
    self.init(searcher: searcher,
              interactor: interactor,
              filterState: filterState,
              connectSearcher: interactor.connectPlacesSearcher)
  }

}
