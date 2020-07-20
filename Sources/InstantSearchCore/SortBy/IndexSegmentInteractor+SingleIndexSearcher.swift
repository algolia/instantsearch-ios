//
//  IndexSegmentInteractor+SingleIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension IndexSegment {

  struct SingleIndexSearcherConnection: Connection {

    let interactor: IndexSegmentInteractor
    let searcher: SingleIndexSearcher

    public func connect() {
      if let selected = interactor.selected, let index = interactor.items[selected] {
        searcher.indexQueryState.indexName = index.name
        searcher.indexQueryState.query.page = 0
      }

      interactor.onSelectedComputed.subscribePast(with: searcher) { [weak interactor] searcher, computed in
        if
          let selected = computed,
          let index = interactor?.items[selected]
        {
          interactor?.selected = selected
          searcher.indexQueryState.indexName = index.name
          searcher.indexQueryState.query.page = 0
          searcher.search()
        }
      }
    }

    public func disconnect() {
      interactor.onSelectedComputed.cancelSubscription(for: searcher)
    }

  }

}

public extension IndexSegmentInteractor {

  @discardableResult func connectSearcher(searcher: SingleIndexSearcher) -> IndexSegment.SingleIndexSearcherConnection {
    let connection = IndexSegment.SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
