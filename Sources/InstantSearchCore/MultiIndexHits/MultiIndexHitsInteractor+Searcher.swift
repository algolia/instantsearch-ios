//
//  MultiIndexHitsInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 07/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct SearcherConnection: Connection {

    public let interactor: MultiIndexHitsInteractor
    public let searcher: MultiIndexSearcher

    public func connect() {
      zip(interactor.hitsInteractors.indices, searcher.pageLoaders).forEach {
        let (index, pageLoader) = $0
        interactor.hitsInteractors[index].pageLoader = pageLoader
      }

      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.update(searchResults.results)
      }

      searcher.onError.subscribe(with: interactor) { interactor, args in
        let (queries, error) = args
        interactor.process(error, for: queries)
      }

      searcher.onQueryChanged.subscribe(with: interactor) { interactor, _ in
        interactor.notifyQueryChanged()
      }
    }

    public func disconnect() {
      for nestedInteractor in interactor.hitsInteractors {
        nestedInteractor.pageLoader = nil
      }
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
      searcher.onQueryChanged.cancelSubscription(for: interactor)
    }

  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @discardableResult func connectSearcher(_ searcher: MultiIndexSearcher) -> SearcherConnection {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
