//
//  SwitchIndexInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public protocol IndexNameSettable {
  
  func setIndexName(_ indexName: IndexName)
  
}

public extension SwitchIndexInteractor {

  struct SearcherConnection<Searcher: AnyObject & IndexNameSettable>: Connection {

    public let interactor: SwitchIndexInteractor
    public let searcher: Searcher

    public func connect() {
      interactor.onSelectionChange.subscribe(with: searcher) { (_, selectedIndexName) in
        searcher.setIndexName(selectedIndexName)
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: searcher)
    }

  }

  @discardableResult func connectSearcher<Searcher: AnyObject & IndexNameSettable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
