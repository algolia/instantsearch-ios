//
//  FacetListInteractor+CompositionSearcher.swift
//  InstantSearchCore
//

import AlgoliaComposition
import Foundation

public extension FacetListInteractor {
  struct CompositionSearcherConnection: Connection {
    /// Logic applied to the facets
    public let facetListInteractor: FacetListInteractor

    /// Searcher that handles your searches
    public let searcher: CompositionSearcher

    /// Faceting attribute
    public let attribute: String

    /**
     - Parameters:
       - facetListInteractor: Logic applied to the facets
       - searcher: Searcher that handles your searches
       - attribute: Faceting attribute
     */
    public init(facetListInteractor: FacetListInteractor,
                searcher: CompositionSearcher,
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

      searcher.request.params.updateQueryFacets(with: attribute)
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
  @discardableResult func connectSearcher(_ searcher: CompositionSearcher,
                                          with attribute: String) -> CompositionSearcherConnection {
    let connection = CompositionSearcherConnection(facetListInteractor: self,
                                                   searcher: searcher,
                                                   attribute: attribute)
    connection.connect()
    return connection
  }
}

extension CompositionParams {
  mutating func updateQueryFacets(with attribute: String) {
    let existing = facets ?? []
    facets = Array(Set(existing + [attribute]))
  }
}
