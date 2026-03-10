//
//  SearchClientTypealiases.swift
//  InstantSearchCore
//

import AlgoliaCore
import AlgoliaSearch

public typealias SearchHit = Hit<[String: AlgoliaCore.AnyCodable]>

extension SearchResult where T == SearchHit {
  var asSearchResponse: AlgoliaSearch.SearchResponse<SearchHit>? {
    switch self {
    case let .searchResponse(response):
      return response
    case .searchForFacetValuesResponse:
      return nil
    }
  }
}
