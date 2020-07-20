//
//  QueryBuilder.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
public struct QueryBuilder {

  public let query: Query
  public let filterGroups: [FilterGroupType]

  public var keepSelectedEmptyFacets: Bool

  private let disjunctiveFacets: Set<Attribute>

  public let hierarchicalAttributes: [Attribute]
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

  public init(query: Query,
              filterGroups: [FilterGroupType] = [],
              hierarchicalAttributes: [Attribute] = [],
              hierachicalFilters: [Filter.Facet] = []) {
    self.query = query
    self.keepSelectedEmptyFacets = false
    self.filterGroups = filterGroups
    self.disjunctiveFacets = Set(filterGroups
      .compactMap { $0 as? FilterGroup.Or<Filter.Facet> }
      .map { $0.filters }
      .flatMap { $0 }
      .map { $0.attribute })
    self.hierarchicalAttributes = hierarchicalAttributes
    self.hierachicalFilters = hierachicalFilters
  }

  public func build() -> [Query] {

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

    let resultsForFaceting = results.dropFirst()
    let resultsForDisjuncitveFaceting = resultsForFaceting[...disjunctiveFacetingQueriesCount]
    let resultsForHierarchicalFaceting = resultsForFaceting.dropFirst(disjunctiveFacetingQueriesCount)[..<totalQueriesCount]

    let facetStats = results.aggregateFacetStats()
    aggregatedResult.facetStats = facetStats.isEmpty ? nil : facetStats

    aggregatedResult = update(aggregatedResult, withResultsForDisjuncitveFaceting: resultsForDisjuncitveFaceting)
    aggregatedResult = update(aggregatedResult, withResultsForHierarchicalFaceting: resultsForHierarchicalFaceting)

    if keepSelectedEmptyFacets {
      let filters = filterGroups.flatMap { $0.filters }
      aggregatedResult = completeMissingFacets(in: aggregatedResult, disjunctiveFacets: disjunctiveFacets, filters: filters )
    }

    return aggregatedResult

  }

  func update<C: Collection>(_ results: SearchResponse, withResultsForDisjuncitveFaceting resultsForDisjuncitveFaceting: C) -> SearchResponse where C.Element == SearchResponse {
    var output = results
    output.disjunctiveFacets = resultsForDisjuncitveFaceting.aggregateFacets()
    output.exhaustiveFacetsCount = resultsForDisjuncitveFaceting.allSatisfy { $0.exhaustiveFacetsCount == true }
    return output
  }

  func update<C: Collection>(_ results: SearchResponse, withResultsForHierarchicalFaceting resultsForHierarchicalFaceting: C) -> SearchResponse where C.Element == SearchResponse {
    var output = results
    let hierarchicalFacets = resultsForHierarchicalFaceting.aggregateFacets()
    output.hierarchicalFacets = hierarchicalFacets.isEmpty ? nil : hierarchicalFacets
    return output
  }

  public enum Error: Swift.Error {
    case emptyResults
    case queriesResultsCountMismatch(Int, Int)
  }

}

extension SearchResponse: Builder {}
