//
//  LoadingInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 10/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension LoadingInteractor {

  struct SearcherConnection<S: Searcher>: Connection {

    public let interactor: LoadingInteractor
    public let searcher: S

    public func connect() {
      searcher.isLoading.subscribePast(with: interactor) { interactor, isLoading in
        interactor.item = isLoading
      }
    }

    public func disconnect() {
      searcher.isLoading.cancelSubscription(for: interactor)
    }

  }

}

public extension LoadingInteractor {

  @discardableResult func connectSearcher<S: Searcher>(_ searcher: S) -> SearcherConnection<S> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
