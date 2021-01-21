//
//  HitsInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 02/12/2020.
//

import Foundation

public extension HitsInteractor {

  struct SearcherConnection<Service: SearchService>: Connection where Service.Process == Operation, Service.Result == SearchResponse {

    public let interactor: HitsInteractor
    public let searcher: AbstractSearcher<Service>

    public func connect() {

      if let pageLoader = searcher as? PageLoadable {
        interactor.pageLoader = pageLoader
      }

      searcher.onError.subscribe(with: interactor) { interactor, error in
        if let requestError = error as? AbstractSearcher<Service>.RequestError {
          interactor.process(requestError.underlyingError, for: Query())
        }
      }

      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.update(searchResults)
      }

      searcher.onRequestChanged.subscribePast(with: interactor) { interactor, _ in
        interactor.notifyQueryChanged()
      }

    }

    public func disconnect() {
      if interactor.pageLoader === searcher {
        interactor.pageLoader = nil
      }
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
      searcher.onRequestChanged.cancelSubscription(for: interactor)
    }

  }

}

public extension HitsInteractor {

  @discardableResult func connectSearcher<Service: SearchService>(_ searcher: AbstractSearcher<Service>) -> SearcherConnection<Service> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
