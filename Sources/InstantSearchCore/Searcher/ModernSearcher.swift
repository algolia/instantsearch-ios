//
//  ModernSearcher.swift
//  
//
//  Created by Vladislav Fitc on 25/11/2020.
//

import Foundation

/// An entity performing search queries

public class ModernSearcher<Service: SearchService>: Searcher, SequencerDelegate, SearchResultObservable where Service.Process == Operation {
  
  public var query: String? {
    get { return nil }
    set { }
  }
  
  public let onQueryChanged: Observer<String?>
      
  public var searchRequest: Service.Request
  
  public let searchService: Service

  public let isLoading: Observer<Bool>

  public let onSearch: Observer<Void>

  public let onResults: Observer<Service.Result>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public let onError: Observer<Error>

  /// Closure defining the condition under which the search operation should be triggered
  ///
  /// Example: if you don't want search operation triggering in case of empty query, you should set this value
  /// ````
  /// searcher.shouldTriggerSearchForQuery = { query in query.query ?? "" != "" }
  /// ````
  /// - Default value: nil
  public var shouldTriggerSearchForQuery: ((Service.Request) -> Bool)?

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  /**
   - Parameters:
      - index: Index value in which search will be performed
      - query: Instance of Query. By default a new empty instant of Query will be created.
      - requestOptions: Custom request options. Default is nil.
  */
  public init(service: Service, initialRequest: Service.Request) {
    searchService = service
    searchRequest = initialRequest
    sequencer = .init()
    isLoading = .init()
    onResults = .init()
    onError = .init()
    onQueryChanged = .init()
    onSearch = .init()
    sequencer.delegate = self
    onResults.retainLastData = true
    onError.retainLastData = false
    isLoading.retainLastData = true
    updateClientUserAgents()
  }

  public func search() {

    if let shouldTriggerSearch = shouldTriggerSearchForQuery, !shouldTriggerSearch(searchRequest) {
      return
    }

    onSearch.fire(())
    
    let operation = searchService.search(searchRequest) { [weak self, searchRequest] result in
      guard let searcher = self else { return }
      let result = result.mapError { Error(request: searchRequest, error: $0) }
      switch result {
      case .failure(let error):
        searcher.onError.fire(error)
      case .success(let searchResult):
        searcher.onResults.fire(searchResult)
      }
    }
    
    sequencer.orderOperation(operationLauncher: { return operation })
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }
  
  public struct Error: Swift.Error {
    
    public let request: Service.Request
    public let error: Swift.Error
    
    public init(request: Service.Request, error: Swift.Error) {
      self.request = request
      self.error = error
    }
    
  }

}

public protocol IndexProvider {
  
  var indexName: IndexName { get }
  
}

public protocol TextualQueryProvider {
  
  var textualQuery: String? { get set }
  
}


public class ModernIndexSearcher<Service: SearchService>: ModernSearcher<Service> where Service.Process == Operation, Service.Request: IndexProvider {
  
  public override var searchRequest: Service.Request {
    didSet {
      if searchRequest.indexName != oldValue.indexName {
        onIndexChanged.fire(searchRequest.indexName)
      }
    }
  }

  /// Triggered when an index of Searcher changed
  /// - Parameter: equals to a new index value
  public let onIndexChanged: Observer<IndexName>
  
  public override init(service: Service, initialRequest: Service.Request) {
    onIndexChanged = .init()
    super.init(service: service, initialRequest: initialRequest)
  }
  
}

public typealias AnswersSearcher = ModernIndexSearcher<AlgoliaAnswersSearchService>
public typealias SingleIndexSearcher = ModernIndexSearcher<AlgoliaSearchService>

public extension SingleIndexSearcher {
  
  var query: String? {

    get {
      return searchRequest.query.query
    }

    set {
      let oldValue = searchRequest.query.query
      guard oldValue != newValue else { return }
      cancel()
      searchRequest.query.query = newValue
      searchRequest.query.page = 0
      onQueryChanged.fire(newValue)
    }

  }
    
  var client: SearchClient {
    return searchService.client
  }
  
  /// Current index & query tuple
  var indexQueryState: IndexQueryState {
    get {
      return IndexQueryState(indexName: searchRequest.indexName, query: searchRequest.query)
    }
    
    set {
      self.searchRequest = .init(indexName: newValue.indexName, query: newValue.query)
    }
  }
    
  /// Custom request options
  var requestOptions: RequestOptions? {
    get {
      searchService.requestOptions
    }
    
    set {
      searchService.requestOptions = newValue
    }
  }
  
  /// Delegate providing a necessary information for disjuncitve faceting
  weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate? {
    get {
      searchService.disjunctiveFacetingDelegate
    }
    
    set {
      searchService.disjunctiveFacetingDelegate = newValue
    }
  }

  /// Delegate providing a necessary information for hierarchical faceting
  weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate? {
    get {
      searchService.hierarchicalFacetingDelegate
    }
    
    set {
      searchService.hierarchicalFacetingDelegate = newValue
    }
  }

  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  var isDisjunctiveFacetingEnabled: Bool {
    get {
      searchService.isDisjunctiveFacetingEnabled
    }
    
    set {
      searchService.isDisjunctiveFacetingEnabled = newValue
    }
  }

  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  var keepSelectedEmptyFacets: Bool {
    get {
      searchService.keepSelectedEmptyFacets
    }
    
    set {
      searchService.keepSelectedEmptyFacets = newValue
    }
  }
  
  convenience init(client: SearchClient, indexName: IndexName, query: AlgoliaSearchClient.Query = .init()) {
    self.init(service: AlgoliaSearchService(client: client), initialRequest: .init(indexName: indexName, query: query))
  }
  
  convenience init(appID: ApplicationID, apiKey: APIKey, indexName: IndexName, query: AlgoliaSearchClient.Query = .init()) {
    let client = SearchClient(appID: appID, apiKey: apiKey)
    self.init(service: AlgoliaSearchService(client: client), initialRequest: .init(indexName: indexName, query: query))
  }
  
}
