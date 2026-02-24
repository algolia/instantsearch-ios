//
//  SearchClientExtensions.swift
//  InstantSearchCore
//

import Foundation
import Search

extension SearchQuery {
  static func from(_ query: IndexedQuery) -> SearchQuery {
    let params = SearchParamsEncoder.encode(query.query)
    return .searchForHits(SearchForHits(params: params, indexName: query.indexName))
  }

  static func from(_ query: FacetIndexQuery) -> SearchQuery {
    let params = SearchParamsEncoder.encode(query.query)
    let facetsQuery = SearchForFacets(params: params,
                                      facet: query.attribute,
                                      indexName: query.indexName,
                                      facetQuery: query.facetQuery,
                                      type: .facet)
    return .searchForFacets(facetsQuery)
  }
}

extension Array where Element == IndexedQuery {
  func asSearchQueries() -> [SearchQuery] {
    map(SearchQuery.from)
  }
}

extension Array where Element == FacetIndexQuery {
  func asSearchQueries() -> [SearchQuery] {
    map(SearchQuery.from)
  }
}

extension SearchMethodParams {
  init(queries: [SearchQuery], strategy: MultipleQueriesStrategy? = nil) {
    self.init(requests: queries, strategy: strategy?.searchStrategy)
  }
}

