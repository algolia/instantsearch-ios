//
//  FacetListInteractor+FacetSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FacetListInteractor {

  struct FacetSearcherConnection: Connection {

    public let interactor: FacetListInteractor
    public let searcher: FacetSearcher

    public func connect() {

      // When new facet search results then update items

      searcher.onResults.subscribePast(with: interactor) { interactor, facetResults in
        interactor.update(facetResults)
      }

      // For the case of SFFV, very possible that we forgot to add the
      // attribute as searchable in `attributesForFaceting`.

      searcher.onError.subscribe(with: interactor) { _, error in
        guard let requestError = error as? FacetSearcher.RequestError else { return }
        if let error = requestError.underlyingError as? HTTPError, error.statusCode == 400 {
          assertionFailure(error.message?.description ?? "")
        }
      }

    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
    }

  }

}

public extension FacetListInteractor {

  @discardableResult func connectFacetSearcher(_ facetSearcher: FacetSearcher) -> FacetSearcherConnection {
    let connection = FacetSearcherConnection(interactor: self, searcher: facetSearcher)
    connection.connect()
    return connection
  }

}
