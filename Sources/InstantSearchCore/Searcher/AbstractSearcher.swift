//
//  AbstractSearcher.swift
//  
//
//  Created by Vladislav Fitc on 25/11/2020.
//

import Foundation

/// Abstract search business logic
public class AbstractSearcher<Service: SearchService>: Searcher, SequencerDelegate, SearchResultObservable, ErrorObservable where Service.Process == Operation {

  public typealias Request = Service.Request
  public typealias Result = Service.Result

  public var query: String? {
    get {
      return (request as? TextualQueryProvider)?.textualQuery
    }

    set {
      guard var textualQueryRequest = request as? TextualQueryProvider else {
        return
      }
      textualQueryRequest.textualQuery = newValue
      guard let initialRequest = textualQueryRequest as? Request else {
        return
      }
      self.request = initialRequest
    }
  }

  public let onQueryChanged: Observer<String?>

  public var request: Request {
    didSet {
      onRequestChanged.fire(request)
      if let oldRequest = oldValue as? TextualQueryProvider,
         let newRequest = request as? TextualQueryProvider, oldRequest.textualQuery != newRequest.textualQuery {
        cancel()
        onQueryChanged.fire(newRequest.textualQuery)
      }
    }
  }

  /// Service performing searches
  public let service: Service

  public let isLoading: Observer<Bool>

  public let onSearch: Observer<Void>

  /// Triggered when the search request changed
  public let onRequestChanged: Observer<Request>

  public let onResults: Observer<Service.Result>

  /// Triggered when an error occured during search query execution
  /// - Parameter: occured error
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
  public init(service: Service, initialRequest: Request) {
    self.service = service
    request = initialRequest
    sequencer = .init()
    isLoading = .init()
    onResults = .init()
    onError = .init()
    onQueryChanged = .init()
    onSearch = .init()
    onRequestChanged = .init()
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

public extension AbstractSearcher {

  /// Search error composition encapsulating the error returned by the search service and the request for which this error occured
  struct RequestError: Error {

    /// Request for which an error occured
    public let request: Request

    /// Error returned by the search service
    public let underlyingError: Error

    public init(request: Request, error: Error) {
      self.request = request
      self.underlyingError = error
    }

  }

}
