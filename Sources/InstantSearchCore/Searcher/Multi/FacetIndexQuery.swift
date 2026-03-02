//
//  FacetIndexQuery.swift
//  InstantSearchCore
//

import Foundation

/// Facet search query tied to a single index.
public struct FacetIndexQuery: Hashable {
  public var indexName: String
  public var attribute: String
  public var facetQuery: String
  public var query: SearchSearchParamsObject

  public init(indexName: String, attribute: String, facetQuery: String, query: SearchSearchParamsObject) {
    self.indexName = indexName
    self.attribute = attribute
    self.facetQuery = facetQuery
    self.query = query
  }
}
