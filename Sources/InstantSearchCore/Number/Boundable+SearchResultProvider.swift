//
//  Boundable+SearchResultProvider.swift
//  
//
//  Created by Vladislav Fitc on 15/12/2020.
//
// swiftlint:disable generic_type_name

import Foundation
import AlgoliaSearchClient

public protocol FacetStatsProvider {
  var facetStats: [Attribute: FacetStats]? { get }
}

extension SearchResponse: FacetStatsProvider {}

@available(*, deprecated, message: "use BoundableHitsSearcherConnection")
public struct BoundableSearchResultProvderConnection<B: Boundable, SearchResponseProvider: SearchResultObservable>: Connection where SearchResponseProvider.SearchResult: FacetStatsProvider {

  public let boundable: B
  public let searchResultProvider: SearchResponseProvider
  public let attribute: Attribute

  public func connect() {
    let attribute = self.attribute
    searchResultProvider.onResults.subscribePastOnce(with: boundable) { boundable, searchResult in
      boundable.computeBoundsFromFacetStats(attribute: attribute, facetStats: searchResult.facetStats)
    }
  }

  public func disconnect() {
    searchResultProvider.onResults.cancelSubscription(for: boundable)
  }

}

extension Boundable {

  @available(*, deprecated, message: "use connectSearcher(_ searcher: HitsSearcher, attribute: Attribute)")
  @discardableResult public func connect<SearchResponseProvider>(_ searchResultProvider: SearchResponseProvider, attribute: Attribute) -> BoundableSearchResultProvderConnection<Self, SearchResponseProvider> {
    let connection = BoundableSearchResultProvderConnection(boundable: self, searchResultProvider: searchResultProvider, attribute: attribute)
    connection.connect()
    return connection
  }

}
