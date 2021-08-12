//
//  AlgoliaSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaSearchService: SearchService {

  public let client: SearchClient

  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  public var isDisjunctiveFacetingEnabled = true

  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  public var keepSelectedEmptyFacets: Bool = true

  /// Delegate providing a necessary information for disjuncitve faceting
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate?

  /// Delegate providing a necessary information for hierarchical faceting
  public weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate?

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with disjunctiveFacetsAttributes provided by DisjunctiveFacetingDelegate to create the necessary queries for disjunctive faceting
  public var disjunctiveFacetsAttributes: Set<Attribute>

  public init(client: SearchClient) {
    self.client = client
    self.disjunctiveFacetsAttributes = []
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    let (queries, completion) = collect(for: request, completion: completion)
    return client.search(queries: queries, requestOptions: request.requestOptions) { completion($0.map(\.results)) }
  }
  
}

extension AlgoliaSearchService {
  
  func collect(for request: Request, completion: @escaping (Swift.Result<SearchResponse, Error>) -> Void) -> (queries: [IndexedQuery], completion: (Swift.Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    let queries: [IndexedQuery]
    let transform: ([MultiIndexSearchResponse.Response]) -> SearchResponse
    if isDisjunctiveFacetingEnabled {
      let filterGroups = disjunctiveFacetingDelegate?.toFilterGroups() ?? []
      let hierarchicalAttributes = hierarchicalFacetingDelegate?.hierarchicalAttributes ?? []
      let hierarchicalFilters = hierarchicalFacetingDelegate?.hierarchicalFilters ?? []
      var queriesBuilder = QueryBuilder(query: request.query,
                                        disjunctiveFacets: disjunctiveFacetsAttributes,
                                        filterGroups: filterGroups,
                                        hierarchicalAttributes: hierarchicalAttributes,
                                        hierachicalFilters: hierarchicalFilters)
      queriesBuilder.keepSelectedEmptyFacets = keepSelectedEmptyFacets
      queries = queriesBuilder.build().map { IndexedQuery(indexName: request.indexName, query: $0) }
      // swiftlint:disable:next force_try
      transform = { try! queriesBuilder.aggregate($0.compactMap(\.hitsResponse)) }
    } else {
      queries = [IndexedQuery(indexName: request.indexName, query: request.query)]
      transform = { $0.first!.hitsResponse! }
    }

    return (queries, { completion($0.map(transform)) })
  }
  
}

extension AlgoliaSearchService {

  public struct Request: IndexNameProvider, TextualQueryProvider, AlgoliaRequest {

    public var indexName: IndexName
    public var query: Query
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get {
        query.query
      }
      set {
        query.query = newValue
      }
    }

    public init(indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
      self.indexName = indexName
      self.query = query
      self.requestOptions = requestOptions
    }

  }

}
