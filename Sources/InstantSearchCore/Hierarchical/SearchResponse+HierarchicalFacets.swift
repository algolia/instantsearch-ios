//
//  SearchResponse+HierarchicalFacets.swift
//  InstantSearchCore
//

import Foundation
import Search

extension SearchResponse {
  /// Maps facet counts into hierarchical facet hits grouped by attribute.
  var hierarchicalFacets: [String: [FacetHits]]? {
    guard let facets = facets, !facets.isEmpty else { return nil }
    var result: [String: [FacetHits]] = [:]
    for (attribute, values) in facets {
      let hits = values.map { FacetHits(value: $0.key, highlighted: $0.key, count: $0.value) }
      if !hits.isEmpty {
        result[attribute] = hits
      }
    }
    return result.isEmpty ? nil : result
  }
}


