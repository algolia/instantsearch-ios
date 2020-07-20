//
//  FacetListInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
public extension FacetListInteractor {

  struct SingleIndexSearcherConnection: Connection {

    public let facetListInteractor: FacetListInteractor
    public let searcher: SingleIndexSearcher
    public let attribute: Attribute

    public func connect() {

      // When new search results then update items

      searcher.onResults.subscribePast(with: facetListInteractor) { [attribute] interactor, searchResults in
        interactor.items = searchResults.disjunctiveFacets?[attribute] ?? searchResults.facets?[attribute] ?? []
      }

      searcher.indexQueryState.query.updateQueryFacets(with: attribute)

    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: facetListInteractor)
    }

  }

}

public extension FacetListInteractor {

  @discardableResult func connectSearcher(_ searcher: SingleIndexSearcher, with attribute: Attribute) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(facetListInteractor: self, searcher: searcher, attribute: attribute)
    connection.connect()
    return connection
  }

}
