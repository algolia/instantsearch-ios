//
//  FacetListInteractor+CompositionFacetSearcher.swift
//  InstantSearchCore
//

import AlgoliaCore
import Foundation

public extension FacetListInteractor {
  struct CompositionFacetSearcherConnection: Connection {
    /// Logic applied to the facets
    public let interactor: FacetListInteractor

    /// Searcher that handles your facet values searches
    public let searcher: CompositionFacetSearcher

    /**
     - Parameters:
       - interactor: Logic applied to the facets
       - searcher: Searcher that handles your facet values searches
     */
    public init(interactor: FacetListInteractor,
                searcher: CompositionFacetSearcher) {
      self.interactor = interactor
      self.searcher = searcher
    }

    public func connect() {
      // When new facet search results then update items
      searcher.onResults.subscribePast(with: interactor) { interactor, facetResults in
        interactor.update(facetResults)
      }

      // For the case of SFFV, very possible that we forgot to add the
      // attribute as searchable in `attributesForFaceting`.
      searcher.onError.subscribe(with: interactor) { _, error in
        guard let requestError = error as? CompositionFacetSearcher.RequestError else { return }
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
  /**
   - Parameters:
     - facetSearcher: Searcher that handles your facet values searches
   */
  @discardableResult func connectFacetSearcher(_ facetSearcher: CompositionFacetSearcher) -> CompositionFacetSearcherConnection {
    let connection = CompositionFacetSearcherConnection(interactor: self, searcher: facetSearcher)
    connection.connect()
    return connection
  }
}
