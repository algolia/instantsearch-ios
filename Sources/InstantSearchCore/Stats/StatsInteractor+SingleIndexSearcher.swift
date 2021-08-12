//
//  StatsInteractor+SingleIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension StatsInteractor {

  @available(*, deprecated, message: "Use StatsInteractor.SearcherConnection")
  struct SingleIndexSearcherConnection: Connection {

    let interactor: StatsInteractor
    let searcher: HitsSearcher

    public func connect() {
      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.item = searchResults.searchStats
      }
      searcher.onError.subscribe(with: interactor) { interactor, _ in
        interactor.item = .none
      }
    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
    }

  }

}

public extension StatsInteractor {

  @discardableResult func connectSearcher<Searcher: SearchResultObservable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
