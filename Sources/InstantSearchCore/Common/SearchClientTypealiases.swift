//
//  SearchClientTypealiases.swift
//  InstantSearchCore
//

import Core
import Search

public typealias SearchHit = Hit<[String: AnyCodable]>

extension SearchResult where T == SearchHit {
  var asSearchResponse: Search.SearchResponse<SearchHit>? {
    switch self {
    case let .searchResponse(response):
      return response
    case .searchForFacetValuesResponse:
      return nil
    }
  }
}

