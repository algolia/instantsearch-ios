//
//  FacetListInteractor+HitsSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
public extension FacetListInteractor {
  @available(*, deprecated, renamed: "HitsSearcherConnection")
  typealias SingleIndexSearcherConnection = HitsSearcherConnection

  struct HitsSearcherConnection: Connection {
    /// Logic applied to the facets
    public let facetListInteractor: FacetListInteractor

    /// Searcher that handles your searches
    public let searcher: HitsSearcher

    /// Faceting attribute
    public let attribute: String

    /**
     - Parameters:
       - facetListInteractor: Logic applied to the facets
       - searcher: Searcher that handles your searches
       - attribute: Faceting attribute
     */
    public init(facetListInteractor: FacetListInteractor,
                searcher: HitsSearcher,
                attribute: String) {
      self.facetListInteractor = facetListInteractor
      self.searcher = searcher
      self.attribute = attribute
    }

    public func connect() {
      // When new search results then update items

      searcher.onResults.subscribePast(with: facetListInteractor) { [attribute] interactor, searchResults in
        let facets = searchResults.facets?[attribute] ?? [:]
        interactor.items = facets.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
      }

      searcher.request.query.updateQueryFacets(with: attribute)
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
  @discardableResult func connectSearcher(_ searcher: HitsSearcher,
                                          with attribute: String) -> HitsSearcherConnection {
    let connection = HitsSearcherConnection(facetListInteractor: self,
                                            searcher: searcher,
                                            attribute: attribute)
    connection.connect()
    return connection
  }
}
