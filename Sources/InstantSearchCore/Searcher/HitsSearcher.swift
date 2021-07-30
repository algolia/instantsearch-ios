//
//  HitsSearcher.swift
//  
//
//  Created by Vladislav Fitc on 22/07/2021.
//

import Foundation
import AlgoliaSearchClient

public protocol SearchState: AnyObject {
  
  func buildQueries() -> [IndexedQuery]
  func update(with result: Result<[MultiIndexSearchResponse.Response], Error>)
  
}

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class MultiIndexSearchService: SearchService {
      
  let client: SearchClient
  
  var states: [WeakSearchState] = []
  
  public class WeakSearchState {
    weak var value: SearchState?
    init (value: SearchState) {
      self.value = value
    }
  }
  
  init(client: SearchClient) {
    self.client = client
    self.states = []
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey) {
    self.init(client: SearchClient(appID: appID, apiKey: apiKey))
  }
  
  public func performRequest() {
    
    let queriesPerState: [(state: SearchState, queries: [IndexedQuery])] = states.compactMap { $0.value }.map { ($0, $0.buildQueries()) }
    
    var rangePerState: [(state: SearchState, range: Range<Int>)] = []
    
    var lowerBound: Int = 0
    for (state, queries) in queriesPerState {
      let nextLowerBound = lowerBound+queries.count
      rangePerState.append((state, lowerBound..<nextLowerBound))
      lowerBound = nextLowerBound
    }
    
    let queries = queriesPerState.flatMap(\.queries)
    
    // Add sequencing logic
    _ = client.search(queries: queries, strategy: .none, requestOptions: nil) { result in
      rangePerState.forEach { (state, range) in
        let resultForState = result.map { Array($0.results[range]) }
        state.update(with: resultForState)
      }
    }
    
  }
  
  public func search(_ request: [WeakSearchState], completion: @escaping (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) -> Operation {
    let queriesPerState: [(state: SearchState, queries: [IndexedQuery])] = request.compactMap { $0.value }.map { ($0, $0.buildQueries()) }
    
    var rangePerState: [(state: SearchState, range: Range<Int>)] = []
    
    var lowerBound: Int = 0
    for (state, queries) in queriesPerState {
      let nextLowerBound = lowerBound+queries.count
      rangePerState.append((state, lowerBound..<nextLowerBound))
      lowerBound = nextLowerBound
    }
    
    let queries = queriesPerState.flatMap(\.queries)
    
    // Add sequencing logic
    return client.search(queries: queries, strategy: .none, requestOptions: nil) { result in
      rangePerState.forEach { (state, range) in
        let resultForState = result.map { Array($0.results[range]) }
        state.update(with: resultForState)
      }
    }
  }
  
}


public class HitsSearcher: SearchState {
  
  /// Current request
  public var request: AlgoliaSearchService.Request
  
  public let service: MultiIndexSearchService
  
  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  public var keepSelectedEmptyFacets: Bool = true
  
  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with disjunctiveFacetsAttributes provided by DisjunctiveFacetingDelegate to create the necessary queries for disjunctive faceting
  public var disjunctiveFacetsAttributes: Set<Attribute>
  
  /// Delegate providing a necessary information for disjuncitve faceting
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate?
  
  /// Delegate providing a necessary information for hierarchical faceting
  public weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate?
  
  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  public var isDisjunctiveFacetingEnabled = true
  
  public init(service: MultiIndexSearchService, request: AlgoliaSearchService.Request) {
    self.service = service
    self.request = request
    disjunctiveFacetsAttributes = []
    service.states.append(.init(value: self))
  }
  
  public convenience init(service: MultiIndexSearchService, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(service: service, request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }
  
  public convenience init(appID: ApplicationID, apiKey: APIKey, request: AlgoliaSearchService.Request) {
    let service = MultiIndexSearchService(client: SearchClient(appID: appID, apiKey: apiKey))
    self.init(service: service, request: request)
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(appID: appID, apiKey: apiKey, request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }
  
  
  public func buildQueries() -> [IndexedQuery] {
    
    guard isDisjunctiveFacetingEnabled else {
      return [IndexedQuery(indexName: request.indexName, query: request.query)]
    }
    
    let filterGroups = disjunctiveFacetingDelegate?.toFilterGroups() ?? []
    let hierarchicalAttributes = hierarchicalFacetingDelegate?.hierarchicalAttributes ?? []
    let hierarchicalFilters = hierarchicalFacetingDelegate?.hierarchicalFilters ?? []
    var queriesBuilder = QueryBuilder(query: request.query,
                                      disjunctiveFacets: disjunctiveFacetsAttributes,
                                      filterGroups: filterGroups,
                                      hierarchicalAttributes: hierarchicalAttributes,
                                      hierachicalFilters: hierarchicalFilters)
    queriesBuilder.keepSelectedEmptyFacets = keepSelectedEmptyFacets
    return queriesBuilder.build().map { IndexedQuery(indexName: request.indexName, query: $0) }
    
  }
  
  public func update(with result: Result<[MultiIndexSearchResponse.Response], Error>) {
    
  }
  
}

public class FacetsSearcher: SearchState {
  
  /// Current request
  var request: FacetSearchService.Request
  
  public let service: MultiIndexSearchService
  
  public init(service: MultiIndexSearchService, request: FacetSearchService.Request) {
    self.service = service
    self.request = request
    service.states.append(.init(value: self))
  }
  
  public convenience init(service: MultiIndexSearchService, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: service, request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
  public convenience init(appID: ApplicationID, apiKey: APIKey, request: FacetSearchService.Request) {
    self.init(service: .init(client: SearchClient(appID: appID, apiKey: apiKey)), request: request)
  }
  
  public convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(appID: appID, apiKey: apiKey, request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
  public func buildQueries() -> [IndexedQuery] {
    return [.init(indexName: request.indexName, query: request.context, attribute: request.attribute, facetQuery: request.query)]
  }
  
  public func update(with result: Result<[MultiIndexSearchResponse.Response], Error>) {
    
  }
  
}


func example() {
  
// Independent searchers with a shared query

let sharedQuery = Query()

let hitsSearcher1 = HitsSearcher(appID: "appID1",
                                 apiKey: "apiKey1",
                                 indexName: "myIndex1",
                                 query: sharedQuery)

let hitsSearcher2 = HitsSearcher(appID: "appID2",
                                 apiKey: "apiKey2",
                                 indexName: "myIndex2",
                                 query: sharedQuery)

let facetsSearcher = FacetsSearcher(appID: "appID3",
                                    apiKey: "apiKey3",
                                    indexName: "myIndex",
                                    query: sharedQuery,
                                    attribute: "brand",
                                    facetQuery: "")

// Searchers sharing the search service and query

let sharedSearchService = MultiIndexSearchService(appID: "anotherAppID", apiKey: "apiKey")

let hitsSearcher12 = HitsSearcher(service: sharedService,
                                  indexName: "myIndex1",
                                  query: sharedQuery)

let hitsSearcher22 = HitsSearcher(service: sharedService,
                                  indexName: "myIndex2",
                                  query: sharedQuery)

let facetsSearcher2 = FacetsSearcher(service: sharedService,
                                     indexName: "myIndex",
                                     query: sharedQuery,
                                     attribute: "brand",
                                     facetQuery: "")
  
  
}
