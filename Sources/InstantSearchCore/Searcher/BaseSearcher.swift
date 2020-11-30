//
//  ModernSearcher.swift
//  
//
//  Created by Vladislav Fitc on 25/11/2020.
//

import Foundation

/// An entity performing search queries

public class BaseSearcher<Service: SearchService>: Searcher, SequencerDelegate, SearchResultObservable where Service.Process == Operation {
  
  public typealias Request = Service.Request
  public typealias Result = Service.Result

  public var query: String? {
    get { return nil }
    set { }
  }
  
  public let onQueryChanged: Observer<String?>
      
  public var request: Request
  
  public let service: Service

  public let isLoading: Observer<Bool>

  public let onSearch: Observer<Void>

  public let onResults: Observer<Service.Result>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public let onError: Observer<RequestError>

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
  public init(service: Service, initialRequest: Request) {
    self.service = service
    request = initialRequest
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

    if let shouldTriggerSearch = shouldTriggerSearchForQuery, !shouldTriggerSearch(request) {
      return
    }

    onSearch.fire(())
    
    let operation = service.search(request) { [weak self, request] result in
      guard let searcher = self else { return }
      let result = result.mapError { RequestError(request: request, error: $0) }
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
  

}

public extension BaseSearcher {
  
  struct RequestError: Error {
    
    public let request: Request
    public let error: Error
    
    public init(request: Request, error: Error) {
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


public class IndexSearcher<Service: SearchService>: BaseSearcher<Service> where Service.Process == Operation, Service.Request: IndexProvider {
  
  public override var request: Request {
    didSet {
      if request.indexName != oldValue.indexName {
        onIndexChanged.fire(request.indexName)
      }
    }
  }

  /// Triggered when an index of Searcher changed
  /// - Parameter: equals to a new index value
  public let onIndexChanged: Observer<IndexName>
  
  public override init(service: Service, initialRequest: Request) {
    onIndexChanged = .init()
    super.init(service: service, initialRequest: initialRequest)
  }
  
}

public typealias AnswersSearcher = IndexSearcher<AlgoliaAnswersSearchService>
