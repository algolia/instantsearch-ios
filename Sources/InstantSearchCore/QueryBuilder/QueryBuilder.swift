//
//  QueryBuilder.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
public struct QueryBuilder {
  public let query: SearchSearchParamsObject
  public let filterGroups: [FilterGroupType]

  public var keepSelectedEmptyFacets: Bool

  private let disjunctiveFacets: Set<String>

  public let hierarchicalAttributes: [String]
  public let hierachicalFilters: [Filter.Facet]

  public let resultQueriesCount: Int = 1

  public var disjunctiveFacetingQueriesCount: Int {
    return disjunctiveFacets.count
  }

  public var hierarchicalFacetingQueriesCount: Int {
    if hierarchicalAttributes.count == hierachicalFilters.count {
      return hierarchicalAttributes.count
    }
    return hierachicalFilters.isEmpty ? 0 : hierachicalFilters.count + 1
  }

  public var totalQueriesCount: Int {
    return resultQueriesCount + disjunctiveFacetingQueriesCount + hierarchicalFacetingQueriesCount
  }

  public init(query: SearchSearchParamsObject,
              disjunctiveFacets: Set<String> = [],
              filterGroups: [FilterGroupType] = [],
              hierarchicalAttributes: [String] = [],
              hierachicalFilters: [Filter.Facet] = []) {
    let disjunctiveFacetsFromFilters = filterGroups
      .compactMap { $0 as? FilterGroup.Or<Filter.Facet> }
      .map { $0.filters }
      .flatMap { $0 }
      .map { $0.attribute }
    self.query = query
    keepSelectedEmptyFacets = false
    self.filterGroups = filterGroups
    self.disjunctiveFacets = disjunctiveFacets.union(disjunctiveFacetsFromFilters)
    self.hierarchicalAttributes = hierarchicalAttributes
    self.hierachicalFilters = hierachicalFilters
  }

  public func build() -> [SearchSearchParamsObject] {
    var queryForResults = query
    queryForResults.filters = FilterGroupConverter().sql(filterGroups)

    let disjunctiveFacetingQueries = buildDisjunctiveFacetingQueries(query: query,
                                                                     filterGroups: filterGroups,
                                                                     disjunctiveFacets: disjunctiveFacets)

    let hierarchicalFacetingQueries = buildHierarchicalQueries(with: query,
                                                               filterGroups: filterGroups,
                                                               hierarchicalAttributes: hierarchicalAttributes,
                                                               hierachicalFilters: hierachicalFilters)

    return [queryForResults] + disjunctiveFacetingQueries + hierarchicalFacetingQueries
  }

  public func aggregate(_ results: [SearchResponse]) throws -> SearchResponse {
    guard var aggregatedResult = results.first else {
      throw Error.emptyResults
    }

    if results.count != totalQueriesCount {
      throw Error.queriesResultsCountMismatch(totalQueriesCount, results.count)
    }

    let resultsForDisjuncitveFaceting = results.dropFirst().prefix(disjunctiveFacetingQueriesCount)

    let facetStats = results.aggregateFacetStats()
    aggregatedResult.facetsStats = facetStats.isEmpty ? nil : facetStats

    let aggregatedFacets = results.aggregateFacets()
    aggregatedResult.facets = aggregatedFacets.isEmpty ? nil : aggregatedFacets

    let exhaustiveFacets = resultsForDisjuncitveFaceting
      .compactMap { $0.exhaustive?.facetsCount }
    if !exhaustiveFacets.isEmpty {
      aggregatedResult.exhaustiveFacetsCount = exhaustiveFacets.allSatisfy { $0 }
    }

    if keepSelectedEmptyFacets {
      let filters = filterGroups.flatMap { $0.filters }
      aggregatedResult = completeMissingFacets(in: aggregatedResult, disjunctiveFacets: disjunctiveFacets, filters: filters)
    }

    return aggregatedResult
  }

  public enum Error: Swift.Error {
    case emptyResults
    case queriesResultsCountMismatch(Int, Int)
  }
}
