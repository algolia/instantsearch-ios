//
//  DynamicFacetListInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetListInteractor {

  /// Connection between a dynamic facets business logic and a searcher
  struct SearcherConnection<Searcher: SearchResultObservable>: Connection where Searcher.SearchResult == SearchResponse {

    /// Dynamic facet list business logic
    public let interactor: DynamicFacetListInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    /**
     - parameters:
       - interactor: Dynamic facet list business logic
       - searcher: Searcher to connect
    */
    public init(interactor: DynamicFacetListInteractor,
                searcher: Searcher) {
      self.searcher = searcher
      self.interactor = interactor
    }

    public func connect() {
      searcher.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        interactor.update(with: searchResponse)
      }
      (searcher as? ErrorObservable)?.onError.subscribe(with: interactor) { interactor, _ in
        interactor.orderedFacets = []
      }
    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      (searcher as? ErrorObservable)?.onError.cancelSubscription(for: interactor)
    }

  }

  /**
   Establishes connection with a Searcher
   - parameter searcher: searcher to connect
   */
  @discardableResult func connectSearcher<Searcher: SearchResultObservable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}

extension DynamicFacetListInteractor {

  /// Update `orderedFacets` property with `renderingContent` and
  /// `facets`/`disjunctiveFacets` received of the `SearchResponse` instance
  public func update(with searchResponse: SearchResponse) {
    guard let facetOrdering = searchResponse.renderingContent?.facetOrdering else {
      orderedFacets = []
      return
    }
    let commonFacets = searchResponse.facets ?? [:]
    let disjunctiveFacets = searchResponse.disjunctiveFacets ?? [:]
    let facets = disjunctiveFacets.merging(commonFacets, uniquingKeysWith: { disjunctiveFacets, _ in disjunctiveFacets })
    orderedFacets = FacetsOrderer(facetOrder: facetOrdering, facets: facets)()
  }

}
