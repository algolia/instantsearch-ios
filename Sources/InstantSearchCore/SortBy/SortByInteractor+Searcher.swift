//
//  SortByInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

public extension SortByInteractor {

  struct SearcherConnection<Searcher: AnyObject & Searchable & IndexNameSettable>: Connection {

    /// Business logic component that handles the sort logic
    public let interactor: SortByInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    public func connect() {
      interactor.onSelectedComputed.subscribePast(with: searcher) { [weak interactor] searcher, computed in
        if let selected = computed,
           let indexName = interactor?.items[selected] {
          interactor?.selected = selected
          searcher.setIndexName(indexName)
          searcher.search()
        }
      }
    }

    public func disconnect() {
      interactor.onSelectedComputed.cancelSubscription(for: searcher)
    }

  }

}

public extension SortByInteractor {

  @discardableResult func connectSearcher<Searcher: AnyObject & Searchable & IndexNameSettable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
