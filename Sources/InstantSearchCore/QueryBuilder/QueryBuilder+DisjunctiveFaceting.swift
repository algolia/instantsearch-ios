//
//  QueryBuilder+DisjunctiveFaceting.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
/// Provides convenient method for building disjuncitve faceting queries and parsing disjunctive faceting

extension QueryBuilder {

  /// Constructs dictionary of raw facets for attribute with filters and set of disjunctive faceting attributes
  /// - parameter disjunctiveFacets: set of disjuncitve faceting attributes
  /// - parameter filters: list of filters containing disjunctive facets
  /// - returns: dictionary mapping disjunctive faceting attributes to list of raw facets

  private func facetDictionary(with disjunctiveFacets: Set<Attribute>, filters: [FilterType]) -> [Attribute: [String]] {
    return disjunctiveFacets.map { attribute -> (Attribute, [String]) in
      let values = filters
        .compactMap { $0 as? Filter.Facet }
        .filter { $0.attribute == attribute  }
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

  private func typedFacetDictionary(with dict: [Attribute: [String]]) -> [Attribute: [Facet]] {
    return dict
      .map { (attribute, facetValues) -> (Attribute, [Facet]) in
        let facets = facetValues.map { Facet(value: $0, count: 0, highlighted: .none) }
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

  private func completeMissingFacets(in results: SearchResponse, with facets: [Attribute: [String]]) -> SearchResponse {

    var output = results

    func complete(lhs: [Facet], withFacetValues facetValues: Set<String>) -> [Facet] {
      let existingValues = lhs.map { $0.value }
      return lhs + facetValues.subtracting(existingValues).map { Facet(value: $0, count: 0, highlighted: .none) }
    }

    guard let currentDisjunctiveFacets = results.disjunctiveFacets else {
      output.disjunctiveFacets = typedFacetDictionary(with: facets)
      return output
    }

    facets.forEach { attribute, values in
      let facets = currentDisjunctiveFacets[attribute] ?? []
      let completedFacets = complete(lhs: facets, withFacetValues: Set(values))
      output.disjunctiveFacets?[attribute] = completedFacets
    }

    return output

  }

  /// Completes disjunctive faceting result with currently selected facets with empty results
  /// - parameter results: base disjuncitve faceting results
  /// - parameter facets: set of attribute of facets
  /// - returns: disjuncitve faceting results enriched with selected but empty facets

  func completeMissingFacets(in results: SearchResponse, disjunctiveFacets: Set<Attribute>, filters: [FilterType]) -> SearchResponse {
    let facetDictionary = self.facetDictionary(with: disjunctiveFacets, filters: filters)
    return completeMissingFacets(in: results, with: facetDictionary)
  }

  /// Builds disjunctive faceting queries for each facet
  /// - parameter query: source query
  /// - parameter filterGroups:
  /// - parameter disjunctiveFacets: attributes of disjunctive facets
  /// - returns: list of "or" queries for disjunctive faceting

  func buildDisjunctiveFacetingQueries(query: Query, filterGroups: [FilterGroupType], disjunctiveFacets: Set<Attribute>) -> [Query] {
    return disjunctiveFacets.map { query.disjunctiveFacetingQuery(disjunctiveFacetAttribute: $0, with: filterGroups) }
  }

}

extension Query {

  func disjunctiveFacetingQuery(disjunctiveFacetAttribute: Attribute, with filterGroups: [FilterGroupType]) -> Query {
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

  func droppingDisjunctiveFacetFilters(with attribute: Attribute) -> Self {
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
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }

}

extension Collection {

  func anySatisfy(_ predicate: (Element) -> Bool) -> Bool {
    // swiftlint:disable reduce_boolean
    return reduce(false) { $0 || predicate($1) }
  }

}

extension Collection where Element == SearchResponse {

  func aggregateFacets() -> [Attribute: [Facet]] {
    return compactMap { $0.facets }.reduce([:]) { (aggregatedFacets, facets) in
      aggregatedFacets.merging(facets) { (_, new) in new }
    }
  }

  func aggregateFacetStats() -> [Attribute: FacetStats] {
    return compactMap { $0.facetStats }.reduce([:]) { (aggregatedFacetStats, facetStats) in
      aggregatedFacetStats.merging(facetStats) { (_, new) in new }
    }
  }

}
