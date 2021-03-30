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

    /// Logic applied to the facets
    public let facetListInteractor: FacetListInteractor

    /// Searcher that handles your searches
    public let searcher: SingleIndexSearcher

    /// Faceting attribute
    public let attribute: Attribute

    /**
     - Parameters:
       - facetListInteractor: Logic applied to the facets
       - searcher: Searcher that handles your searches
       - attribute: Faceting attribute
     */
    public init(facetListInteractor: FacetListInteractor,
                searcher: SingleIndexSearcher,
                attribute: Attribute) {
      self.facetListInteractor = facetListInteractor
      self.searcher = searcher
      self.attribute = attribute
    }

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

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - attribute: Faceting attribute
   */
  @discardableResult func connectSearcher(_ searcher: SingleIndexSearcher,
                                          with attribute: Attribute) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(facetListInteractor: self,
                                                   searcher: searcher,
                                                   attribute: attribute)
    connection.connect()
    return connection
  }

}
