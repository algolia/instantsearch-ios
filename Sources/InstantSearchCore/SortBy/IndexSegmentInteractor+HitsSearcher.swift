//
//  IndexSegmentInteractor+HitsSearcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension IndexSegment {
  
  @available(*, deprecated, renamed: "HitsSearcherConnection")
  typealias SingleIndexSearcherConnection = HitsSearcherConnection

  struct HitsSearcherConnection: Connection {

    let interactor: IndexSegmentInteractor
    let searcher: HitsSearcher

    public func connect() {
      if let selected = interactor.selected, let index = interactor.items[selected] {
        searcher.request.indexName = index.name
        searcher.request.query.page = 0
      }

      interactor.onSelectedComputed.subscribePast(with: searcher) { [weak interactor] searcher, computed in
        if
          let selected = computed,
          let index = interactor?.items[selected]
        {
          interactor?.selected = selected
          searcher.request.indexName = index.name
          searcher.request.query.page = 0
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

  @discardableResult func connectSearcher(searcher: HitsSearcher) -> IndexSegment.HitsSearcherConnection {
    let connection = IndexSegment.HitsSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
