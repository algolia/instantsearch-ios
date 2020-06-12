//
//  StatsInteractor+SingleIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension StatsInteractor {

  struct SingleIndexSearcherConnection: Connection {

    let interactor: StatsInteractor
    let searcher: SingleIndexSearcher

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

  @discardableResult func connectSearcher(_ searcher: SingleIndexSearcher) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
