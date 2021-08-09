//
//  HitsSearcher.swift
//  
//
//  Created by Vladislav Fitc on 22/07/2021.
//

import Foundation
import AlgoliaSearchClient

public protocol ComposableSearcher: AnyObject {
  
  func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void)
  
}


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


public class HitsSearcher<Service: SearchService>: ComposableSearcher where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
  
  var service: Service?
  
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
  
  public init(service: Service? = nil, request: AlgoliaSearchService.Request) {
    self.service = service
    self.request = request
    disjunctiveFacetsAttributes = []
  }
  
  public convenience init(service: Service? = nil, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
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
    
  func search() {
    guard let service = service else { return }
    
    let (queries, completion) = fetch()
    
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
    
}

public extension HitsSearcher where Service == SearchClient {
  
  convenience init(request: AlgoliaSearchService.Request) {
    self.init(service: nil, request: request)
  }

  convenience init(appID: ApplicationID, apiKey: APIKey, request: AlgoliaSearchService.Request) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: request)
  }

  convenience init(indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(service: nil, request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, requestOptions: RequestOptions? = nil) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: .init(indexName: indexName, query: query, requestOptions: requestOptions))
  }

}

public class FacetsSearcher<Service: SearchService>: ComposableSearcher where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
  
  var service: Service?
  
  /// Current request
  var request: FacetSearchService.Request
    
  public init(service: Service? = nil, request: FacetSearchService.Request) {
    self.service = service
    self.request = request
  }
  
  public convenience init(service: Service? = nil, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: service, request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
  public func buildQueries() -> [IndexedQuery] {
    return [.init(indexName: request.indexName, query: request.context, attribute: request.attribute, facetQuery: request.query)]
  }
  
  public func update(with result: Result<[MultiIndexSearchResponse.Response], Error>) {
    
  }
  
  public func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    return (buildQueries(), { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let responses):
        let response = responses.first.flatMap(\.facetResponse)
      }
    })
  }
  
  
  func search() {
    guard let service = service else { return }
    
    let (queries, completion) = fetch()
    
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
  
}

public extension FacetsSearcher where Service == SearchClient {
  
  convenience init(request: FacetSearchService.Request) {
    self.init(service: nil, request: request)
  }

  convenience init(appID: ApplicationID, apiKey: APIKey, request: FacetSearchService.Request) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: request)
  }
  
  convenience init(indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: nil, request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }

  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: Query, attribute: Attribute, facetQuery: String, requestOptions: RequestOptions? = nil) {
    self.init(service: .init(appID: appID, apiKey: apiKey), request: .init(query: facetQuery, indexName: indexName, attribute: attribute, context: query, requestOptions: requestOptions))
  }
  
}

/// Extracts queries from queries sources, performs search request and dispatches the results to the corresponding receivers
public class CompositeSearcher<Service: SearchService>: ComposableSearcher where Service.Request == [IndexedQuery], Service.Result == [MultiIndexSearchResponse.Response] {
    
  let searchers: [ComposableSearcher]
  var service: Service?
  
  init(service: Service?, searchers: [ComposableSearcher]) {
    self.service = service
    self.searchers = searchers
  }
  
  public func fetch() -> (queries: [IndexedQuery], completion: (Result<[MultiIndexSearchResponse.Response], Error>) -> Void) {
    let queriesAndCompletions = searchers.map { $0.fetch() }
    
    let queries = queriesAndCompletions.map(\.queries)
    let completions = queriesAndCompletions.map(\.completion)
    
    func rangesInFlattenList<T>(_ list: [[T]]) -> [Range<Int>] {
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
    
    let rangePerCompletion = zip(completions, rangesInFlattenList(queries))

    return (queries.flatMap { $0 }, { result in
      for (completion, range) in rangePerCompletion {
        let resultForCompletion = result.map { Array($0[range]) }
        completion(resultForCompletion)
      }
    })
  }

  
  func search() {
    guard let service = service else { return }
    
    let (queries, completion) = fetch()
    
    // Add sequencing logic
    let _ = service.search(queries, completion: completion)
  }
  
}

extension CompositeSearcher where Service == SearchClient {
  
  convenience init(appID: ApplicationID, apiKey: APIKey, searcher: ComposableSearcher...) {
    self.init(service: .init(appID: appID, apiKey: apiKey), searchers: searcher)
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, searchers: [ComposableSearcher]) {
    self.init(service: .init(appID: appID, apiKey: apiKey), searchers: searchers)
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
  
    
  let hitsSearcher12 = HitsSearcher(indexName: "myIndex1",
                                    query: sharedQuery)
    
  let hitsSearcher22 = HitsSearcher(indexName: "myIndex2",
                                    query: sharedQuery)
  
  let facetsSearcher2 = FacetsSearcher(indexName: "myIndex",
                                       query: sharedQuery,
                                       attribute: "brand",
                                       facetQuery: "")
  
  let compositeSearcher = CompositeSearcher(appID: "anotherAPPID",
                                            apiKey: "anotherAPIKey",
                                            searchers: [
                                              hitsSearcher12,
                                              hitsSearcher22,
                                              facetsSearcher2
                                            ])
  compositeSearcher.search()
  
  compositeSearcher.search()
  
}

struct QueryInputInteractorTextualQuerySearcher {
  
  
  
}

public protocol Searchable {
  func search()
}

//public extension QueryInputInteractor {
//
//  struct SearcherTextualQueryConnection<S: AnyObject & Searchable & TextualQueryProvider>: Connection {
//
//    public let interactor: QueryInputInteractor
//    public let searcher: S
//    public let searchTriggeringMode: SearchTriggeringMode
//
//    public init(interactor: QueryInputInteractor,
//                searcher: S,
//                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
//      self.interactor = interactor
//      self.searcher = searcher
//      self.searchTriggeringMode = searchTriggeringMode
//    }
//
//    public func connect() {
//
//      interactor.query = searcher.textualQuery
//
//      switch searchTriggeringMode {
//      case .searchAsYouType:
//        interactor.onQueryChanged.subscribe(with: searcher) { searcher, query in
//          searcher.textualQuery = query
//          searcher.search()
//        }
//
//      case .searchOnSubmit:
//        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
//          searcher.textualQuery = query
//          searcher.search()
//        }
//      }
//    }
//
//    public func disconnect() {
//
//      interactor.query = nil
//
//      switch searchTriggeringMode {
//      case .searchAsYouType:
//        interactor.onQueryChanged.cancelSubscription(for: searcher)
//
//      case .searchOnSubmit:
//        interactor.onQuerySubmitted.cancelSubscription(for: searcher)
//      }
//
//    }
//
//  }
//
//}
//
//public extension QueryInputInteractor {
//
//  @discardableResult func connectSearcher<Service: SearchService>(_ searcher: AbstractSearcher<Service>,
//                                                                  searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> TextualQuerySearcherConnection<Service> {
//    let connection = TextualQuerySearcherConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
//    connection.connect()
//    return connection
//  }
//
//}
