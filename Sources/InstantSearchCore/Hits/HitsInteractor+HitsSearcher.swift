//
//  HitsInteractor+Connectors.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension HitsInteractor {
  
  @available(*, deprecated, renamed: "HitsSearcher")
  typealias SingleIndexSearcherConnection = HitsSearcherConnection

  struct HitsSearcherConnection: Connection {

    public let interactor: HitsInteractor
    public let searcher: HitsSearcher

    public func connect() {

      interactor.pageLoader = searcher

      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.update(searchResults)
      }

      searcher.onError.subscribe(with: interactor) { interactor, error in
        if let requestError = error as? HitsSearcher.RequestError {
          interactor.process(requestError.underlyingError, for: requestError.request.query)
        }
      }

      searcher.onIndexChanged.subscribePast(with: interactor) { interactor, _ in
        interactor.notifyQueryChanged()
      }

      searcher.onQueryChanged.subscribePast(with: interactor) { interactor, _ in
        interactor.notifyQueryChanged()
      }

    }

    public func disconnect() {
      if interactor.pageLoader === searcher {
        interactor.pageLoader = nil
      }
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
      searcher.onIndexChanged.cancelSubscription(for: interactor)
      searcher.onQueryChanged.cancelSubscription(for: interactor)
    }

  }

}

public extension HitsInteractor {

  @discardableResult func connectSearcher(_ searcher: HitsSearcher) -> HitsSearcherConnection {
    let connection = HitsSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
