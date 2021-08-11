//
//  HitsSearcher.swift
//  
//
//  Created by Vladislav Fitc on 22/07/2021.
//

import Foundation
import AlgoliaSearchClient


extension SearchClient: SearchService {
  
  public func search(_ queries: [IndexedQuery], completion: @escaping (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) -> Operation {
    return search(queries: queries, strategy: .none, requestOptions: nil) { result in
      completion(result.map(\.results))
    }
  }
  
}

extension MultiIndexSearchResponse.Response {
  
  var hitsResponse: SearchResponse? {
    switch self {
    case .facet:
      return nil
    case .search(let searchResponse):
      return searchResponse
    }
  }
  
  var facetResponse: FacetSearchResponse? {
    switch self {
    case .facet(let facetResponse):
      return facetResponse
    case .search:
      return nil
    }
  }
  
}

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers


public class HitsSearcher<Service: SearchService>: ComposableSearcher, Searchable, TextualQueryProvider where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
  
  public var textualQuery: String? {
    get {
      return request.textualQuery
    }
    
    set {
      request.textualQuery = newValue
    }
  }
  
  
  let service: Service
  
  /// Current request
  public var request: AlgoliaSearchService.Request
    
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
  
  public init(service: Service, request: AlgoliaSearchService.Request) {
    self.service = service
    self.request = request
    disjunctiveFacetsAttributes = []
  }
  
  public convenience init(service: Service, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(service: service, request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }
        
  public func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    let queries: [IndexedQuery]
    
    if !isDisjunctiveFacetingEnabled {
      queries = [IndexedQuery(indexName: request.indexName, query: request.query)]
      return (queries, { result in
        switch result {
        case .failure(let error):
          print(error)
        case .success(let responses):
          let response = responses.first.flatMap(\.hitsResponse)
        }
      })
    } else {
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
      
      return (queries, { result in
        switch result {
        case .failure(let error):
          print(error)
        case .success(let responses):
          do {
            let response = try queriesBuilder.aggregate(responses.compactMap(\.hitsResponse))
          } catch let error {
            
          }
        }
      })
    }
    
  }
    
  public func search() {
    let (queries, completion) = fetch()
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
    
}

public extension HitsSearcher where Service == SearchClient {
  
  convenience init(appID: ApplicationID, apiKey: APIKey, request: AlgoliaSearchService.Request) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: request)
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }

}

public class FacetsSearcher<Service: SearchService>: ComposableSearcher, Searchable, TextualQueryProvider where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
  
  var service: Service
  
  /// Current request
  var request: FacetSearchService.Request
  
  public var textualQuery: String? {
    get {
      return request.textualQuery
    }
    
    set {
      request.textualQuery = newValue
    }
  }
    
  public init(service: Service, request: FacetSearchService.Request) {
    self.service = service
    self.request = request
  }
  
  public convenience init(service: Service, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: service, request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
  public func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    let queries: [IndexedQuery] = [.init(indexName: request.indexName, query: request.context, attribute: request.attribute, facetQuery: request.query)]
    return (queries, { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let responses):
        let response = responses.first.flatMap(\.facetResponse)
      }
    })
  }
  
  
  public func search() {
    let (queries, completion) = fetch()
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
  
}

public extension FacetsSearcher where Service == SearchClient {
  
  convenience init(appID: ApplicationID, apiKey: APIKey, request: FacetSearchService.Request) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: request)
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
}

public protocol ComposableSearcher {
  
  /// Returns the list of queries and the completion that might be called with for the result of these queries
  func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void)
  
}

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class CompositeSearcher<Service: SearchService>: ComposableSearcher, Searchable, TextualQueryProvider where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
  
  var searchers: [ComposableSearcher]
  let service: Service
  
  public var textualQuery: String? {
    get {
      return searchers.compactMap { $0 as? TextualQueryProvider }.first?.textualQuery
    }
    
    set {
      
    }
  }
  
  init(service: Service) {
    self.searchers = []
    self.service = service
  }
  
  public func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    let queriesAndCompletions = searchers.map { $0.fetch() }
    
    let queries = queriesAndCompletions.map(\.queries)
    let completions = queriesAndCompletions.map(\.completion)
    
    /// Maps the nested lists to the ranges corresponding to the positions of the nested list elements in the flatten list
    /// Example: [["a", "b", "c"], ["d", "e"], ["f", "g", "h"]] -> [0..<3, 3..<5, 5..<8]
    func flatRanges<T>(_ list: [[T]]) -> [Range<Int>] {
      var ranges: [Range<Int>] = []
      var offset: Int = 0
      for sublist in list {
        let nextOffset = offset+sublist.count
        let range = offset..<nextOffset
        ranges.append(range)
        offset = nextOffset
      }
      return ranges
    }
    
    let rangePerCompletion = zip(completions, flatRanges(queries))

    return (queries.flatMap { $0 }, { result in
      for (completion, range) in rangePerCompletion {
        let resultForCompletion = result.map { Array($0[range]) }
        completion(resultForCompletion)
      }
    })
  }

  
  public func search() {
    let (queries, completion) = fetch()
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
  
}

extension CompositeSearcher where Service == SearchClient {
  
  convenience init(appID: ApplicationID, apiKey: APIKey) {
    self.init(service: .init(appID: appID, apiKey: apiKey))
  }
  
  @discardableResult func addHitsSearcher(indexName: IndexName, query: Query) -> HitsSearcher<SearchClient> {
    let searcher = HitsSearcher(service: service, indexName: indexName, query: query)
    searchers.append(searcher)
    return searcher
  }
  
  @discardableResult func addFacetsSearcher(indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) -> FacetsSearcher<SearchClient> {
    let searcher = FacetsSearcher(service: service, indexName: indexName, query: query, attribute: attribute, facetQuery: facetQuery, requestOptions: requestOptions)
    searchers.append(searcher)
    return searcher
  }
  
}


func example() {
  
  // Independent searchers with a shared query
  
  let sharedQuery = Query()
  
  let hitsSearcher1 = HitsSearcher(appID: "APPID1",
                                   apiKey: "APIKEY1",
                                   indexName: "myIndex1",
                                   query: sharedQuery)
  
  hitsSearcher1.search()
  
  
  let hitsSearcher2 = HitsSearcher(appID: "APPID2",
                                   apiKey: "APIKEY2",
                                   indexName: "myIndex2",
                                   query: sharedQuery)
  
  hitsSearcher2.search()
  
  
  let facetsSearcher = FacetsSearcher(appID: "APPID3",
                                      apiKey: "APIKEY3",
                                      indexName: "myIndex",
                                      query: sharedQuery,
                                      attribute: "brand",
                                      facetQuery: "")
  
  facetsSearcher.search()
    
  // Searchers sharing the search service and query
    
  let compositeSearcher = CompositeSearcher(appID: "anotherAPPID",
                                            apiKey: "anotherAPIKey")
  compositeSearcher.addHitsSearcher(indexName: "myIndex2", query: sharedQuery)
  compositeSearcher.addHitsSearcher(indexName: "myIndex", query: sharedQuery)
  compositeSearcher.addFacetsSearcher(indexName: "myIndex", query: sharedQuery, attribute: "brand", facetQuery: "")
  
  compositeSearcher.search()
  
  let queryInputInteractor2 = QueryInputInteractor()
  
  queryInputInteractor2.connectSearcher(compositeSearcher)
    
}

struct QueryInputInteractorTextualQuerySearcher {
  
  
  
}

public protocol Searchable {
  func search()
}

public extension QueryInputInteractor {

  struct SearcherTextualQueryConnection<S: AnyObject & Searchable & TextualQueryProvider>: Connection {

    public let interactor: QueryInputInteractor
    public let searcher: S
    public let searchTriggeringMode: SearchTriggeringMode

    public init(interactor: QueryInputInteractor,
                searcher: S,
                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
      self.interactor = interactor
      self.searcher = searcher
      self.searchTriggeringMode = searchTriggeringMode
    }

    public func connect() {

      interactor.query = searcher.textualQuery

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.subscribe(with: searcher) { searcher, query in
//          searcher.textualQuery = query
          searcher.search()
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
//          searcher.textualQuery = query
          searcher.search()
        }
      }
    }

    public func disconnect() {

      interactor.query = nil

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.cancelSubscription(for: searcher)

      case .searchOnSubmit:
        interactor.onQuerySubmitted.cancelSubscription(for: searcher)
      }

    }

  }

}

public extension QueryInputInteractor {

  @discardableResult func connectSearcher<S: AnyObject & Searchable & TextualQueryProvider>(_ searcher: S,
                                                                                            searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> SearcherTextualQueryConnection<S> {
    let connection = SearcherTextualQueryConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
