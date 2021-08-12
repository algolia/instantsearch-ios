//
//  FacetListInteractor+MultiIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 30/03/2021.
//

import Foundation
import AlgoliaSearchClient
public extension FacetListInteractor {

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct MultiIndexSearcherConnection: Connection {

    /// Logic applied to the facets
    public let facetListInteractor: FacetListInteractor

    /// Searcher that handles your searches
    public let searcher: MultiIndexSearcher

    /// Faceting attribute
    public let attribute: Attribute

    /// Index of query in the multi-index search
    public let queryIndex: Int

    /**
     - Parameters:
       - facetListInteractor: Logic applied to the facets
       - searcher: Searcher that handles your searches
       - attribute: Faceting attribute
       - queryIndex: Index of query in the multi-index search
     */
    public init(facetListInteractor: FacetListInteractor,
                searcher: MultiIndexSearcher,
                attribute: Attribute,
                queryIndex: Int) {
      self.facetListInteractor = facetListInteractor
      self.searcher = searcher
      self.attribute = attribute
      self.queryIndex = queryIndex
    }

    public func connect() {

      // When new search results then update items

      searcher.onResults.subscribePast(with: facetListInteractor) { [attribute] interactor, response in
        interactor.items = response.results[queryIndex].disjunctiveFacets?[attribute] ?? response.results[queryIndex].facets?[attribute] ?? []
      }

      searcher.indexQueryStates[queryIndex].query.updateQueryFacets(with: attribute)

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
     - queryIndex: Index of query in the multi-index search
   */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  @discardableResult func connectSearcher(_ searcher: MultiIndexSearcher,
                                          with attribute: Attribute,
                                          queryIndex: Int) -> MultiIndexSearcherConnection {
    let connection = MultiIndexSearcherConnection(facetListInteractor: self,
                                                  searcher: searcher,
                                                  attribute: attribute,
                                                  queryIndex: queryIndex)
    connection.connect()
    return connection
  }

}
