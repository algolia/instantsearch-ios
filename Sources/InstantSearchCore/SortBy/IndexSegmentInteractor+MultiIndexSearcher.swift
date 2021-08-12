//
//  IndexSegmentInteractor+MultiIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 12/09/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension IndexSegment {

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct MultiIndexSearcherConnection: Connection {

    let interactor: IndexSegmentInteractor
    let searcher: MultiIndexSearcher
    let queryIndex: Int

    public func connect() {

      if
        let selected = interactor.selected,
        let index = interactor.items[selected]
      {
        searcher.indexQueryStates[queryIndex].indexName = index.name
        searcher.indexQueryStates[queryIndex].query.page = 0
      }

      let queryIndex = self.queryIndex
      interactor.onSelectedComputed.subscribePast(with: searcher) { [weak interactor] searcher, computed in
        if
          let selected = computed,
          let index = interactor?.items[selected]
        {
          interactor?.selected = selected
          searcher.indexQueryStates[queryIndex].indexName = index.name
          searcher.indexQueryStates[queryIndex].query.page = 0
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

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  @discardableResult func connectSearcher(searcher: MultiIndexSearcher, toQueryAtIndex queryIndex: Int) -> IndexSegment.MultiIndexSearcherConnection {
    let connection = IndexSegment.MultiIndexSearcherConnection(interactor: self, searcher: searcher, queryIndex: queryIndex)
    connection.connect()
    return connection
  }

}
