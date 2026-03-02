//
//  QueryBuilder+DisjunctiveFaceting.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import Search
/// Provides convenient method for building disjuncitve faceting queries and parsing disjunctive faceting

extension QueryBuilder {
  /// Constructs dictionary of raw facets for attribute with filters and set of disjunctive faceting attributes
  /// - parameter disjunctiveFacets: set of disjuncitve faceting attributes
  /// - parameter filters: list of filters containing disjunctive facets
  /// - returns: dictionary mapping disjunctive faceting attributes to list of raw facets

  private func facetDictionary(with disjunctiveFacets: Set<String>, filters: [FilterType]) -> [String: [String]] {
    return disjunctiveFacets.map { attribute -> (String, [String]) in
      let values = filters
        .compactMap { $0 as? Filter.Facet }
        .filter { $0.attribute == attribute }
        .map { $0.value.description }
      return (attribute, values)
    }.reduce([:]) { dict, val in
      return dict.merging([val.0: val.1]) { value, _ in value }
    }
  }

  /// Constructs dictionary of facets for attribute with filters and set of disjunctive faceting attributes
  /// Each generated facet is zero-count
  /// - parameter disjunctiveFacets: set of disjuncitve faceting attributes
  /// - parameter filters: list of filters containing disjunctive facets
  /// - returns: dictionary mapping disjunctive faceting attributes to list of facets

  private func typedFacetDictionary(with dict: [String: [String]]) -> [String: [String: Int]] {
    return dict
      .map { attribute, facetValues -> (String, [String: Int]) in
        let facets = Dictionary(uniqueKeysWithValues: facetValues.map { ($0, 0) })
        return (attribute, facets)
      }
      .reduce([:]) { dict, arg in
        return dict.merging([arg.0: arg.1]) { value, _ in value }
      }
  }

  /// Completes disjunctive faceting result with currently selected facets with empty results
  /// - parameter results: base disjuncitve faceting results
  /// - parameter facets: dictionary of current facets
  /// - returns: disjuncitve faceting results enriched with selected but empty facets

  private func completeMissingFacets(in results: SearchResponse<SearchHit>, with facets: [String: [String]]) -> SearchResponse<SearchHit> {
    var output = results
    var currentFacets = output.facets ?? [:]
    let defaultFacets = typedFacetDictionary(with: facets)
    currentFacets = currentFacets.merging(defaultFacets) { existing, new in
      var merged = existing
      new.forEach { key, value in
        if merged[key] == nil {
          merged[key] = value
        }
      }
      return merged
    }
    output.facets = currentFacets.isEmpty ? nil : currentFacets
    return output
  }

  /// Completes disjunctive faceting result with currently selected facets with empty results
  /// - parameter results: base disjuncitve faceting results
  /// - parameter facets: set of attribute of facets
  /// - returns: disjuncitve faceting results enriched with selected but empty facets

  func completeMissingFacets(in results: SearchResponse<SearchHit>, disjunctiveFacets: Set<String>, filters: [FilterType]) -> SearchResponse<SearchHit> {
    let facetDictionary = self.facetDictionary(with: disjunctiveFacets, filters: filters)
    return completeMissingFacets(in: results, with: facetDictionary)
  }

  /// Builds disjunctive faceting queries for each facet
  /// - parameter query: source query
  /// - parameter filterGroups:
  /// - parameter disjunctiveFacets: attributes of disjunctive facets
  /// - returns: list of "or" queries for disjunctive faceting

  func buildDisjunctiveFacetingQueries(query: SearchSearchParamsObject, filterGroups: [FilterGroupType], disjunctiveFacets: Set<String>) -> [SearchSearchParamsObject] {
    return disjunctiveFacets.map { query.disjunctiveFacetingQuery(disjunctiveFacetAttribute: $0, with: filterGroups) }
  }
}

extension SearchSearchParamsObject {
  func disjunctiveFacetingQuery(disjunctiveFacetAttribute: String, with filterGroups: [FilterGroupType]) -> SearchSearchParamsObject {
    let filterGroups = filterGroups.droppingDisjunctiveFacetFilters(with: disjunctiveFacetAttribute)
    var output = self
    output.facets = [disjunctiveFacetAttribute]
    output.filters = FilterGroupConverter().sql(filterGroups)
    output.attributesToRetrieve = []
    output.attributesToHighlight = []
    output.hitsPerPage = 0
    output.analytics = false
    return output
  }

  mutating func requestOnlyFacets() {
    attributesToRetrieve = []
    attributesToHighlight = []
    hitsPerPage = 0
    analytics = false
  }
}

extension Array where Element == FilterGroupType {
  func droppingDisjunctiveFacetFilters(with attribute: String) -> Self {
    map { group in
      guard let disjunctiveFacetGroup = group as? FilterGroup.Or<Filter.Facet> else {
        return group
      }
      let filtersMinusDisjunctiveFacet = disjunctiveFacetGroup.typedFilters.filter { $0.attribute != attribute }
      return FilterGroup.Or(filters: filtersMinusDisjunctiveFacet, name: group.name)
    }
    .filter { !$0.filters.isEmpty }
  }
}

extension Collection {
  func partition(by predicate: (Element) -> Bool) -> (satisfying: [Element], rest: [Element]) {
    var satisfying: [Element] = []
    var rest: [Element] = []
    for element in self {
      if predicate(element) {
        satisfying.append(element)
      } else {
        rest.append(element)
      }
    }
    return (satisfying, rest)
  }
}

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension Collection {
  func anySatisfy(_ predicate: (Element) -> Bool) -> Bool {
    return reduce(false) { $0 || predicate($1) }
  }
}

extension Collection where Element == SearchResponse<SearchHit> {
  func aggregateFacets() -> [String: [String: Int]] {
    return compactMap { $0.facets }.reduce([:]) { aggregatedFacets, facets in
      aggregatedFacets.merging(facets) { _, new in new }
    }
  }

  func aggregateFacetStats() -> [String: SearchFacetStats] {
    return compactMap { $0.facetsStats }.reduce([:]) { aggregatedFacetStats, facetStats in
      aggregatedFacetStats.merging(facetStats) { _, new in new }
    }
  }
}
