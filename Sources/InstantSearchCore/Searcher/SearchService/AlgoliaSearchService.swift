//
//  AlgoliaSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaSearchService: SearchService, AlgoliaService {
  
  public struct Request: IndexProvider, TextualQueryProvider {
    public var indexName: IndexName
    public var query: Query
    
    public var textualQuery: String? {
      get {
        query.query
      }
      set {
        query.query = newValue
      }
    }
  }
  
  public let client: SearchClient
  public var requestOptions: RequestOptions?
  
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
        
  public init(client: SearchClient) {
    self.client = client
  }
  
  public func search(_ request: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    
    let queries: [IndexedQuery]
    let transform: (SearchesResponse) -> SearchResponse
    if isDisjunctiveFacetingEnabled {
      let filterGroups = disjunctiveFacetingDelegate?.toFilterGroups() ?? []
      let hierarchicalAttributes = hierarchicalFacetingDelegate?.hierarchicalAttributes ?? []
      let hierarchicalFilters = hierarchicalFacetingDelegate?.hierarchicalFilters ?? []
      var queriesBuilder = QueryBuilder(query: request.query,
                                        filterGroups: filterGroups,
                                        hierarchicalAttributes: hierarchicalAttributes,
                                        hierachicalFilters: hierarchicalFilters)
      queriesBuilder.keepSelectedEmptyFacets = keepSelectedEmptyFacets
      queries = queriesBuilder.build().map { IndexedQuery(indexName: request.indexName, query: $0) }
      transform = { try! queriesBuilder.aggregate($0.results) }
    } else {
      queries = [IndexedQuery(indexName: request.indexName, query: request.query)]
      transform = { $0.results.first! }
    }
    
    return client.multipleQueries(queries: queries, requestOptions: requestOptions) { completion($0.map(transform)) }

  }
  
}


