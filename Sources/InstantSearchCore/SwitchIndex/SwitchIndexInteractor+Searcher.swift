//
//  SwitchIndexInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public extension SwitchIndexInteractor {

  struct SearcherConnection<Searcher: AnyObject & Searchable & IndexNameSettable>: Connection {

    /// Business logic component that handles the index name switching
    public let interactor: SwitchIndexInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    public func connect() {
      interactor.onSelectionChange.subscribe(with: searcher) { (_, selectedIndexName) in
        searcher.setIndexName(selectedIndexName)
        searcher.search()
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: searcher)
    }

  }

  /**
   Establishes a connection with a searcher
   - Parameters:
     - searcher: Searcher that handles your searches
   - Returns: Established connection
  */
  @discardableResult func connectSearcher<Searcher: AnyObject & Searchable & IndexNameSettable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
