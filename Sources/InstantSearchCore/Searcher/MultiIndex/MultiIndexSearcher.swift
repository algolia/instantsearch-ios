//
//  MultiIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import Search

/// An entity performing search queries targeting multiple indices.
@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
public class MultiIndexSearcher: Searcher, SequencerDelegate, SearchResultObservable {
  public var query: String? {
    get {
      return indexQueryStates.first?.query.query
    }

    set {
      let oldValue = indexQueryStates.first?.query.query
      guard oldValue != newValue else { return }
      indexQueryStates = indexQueryStates.map { indexQueryState in
        let query = indexQueryState.query.set(\.query, to: newValue).set(\.page, to: 0)
        return indexQueryState.set(\.query, to: query)
      }
      onQueryChanged.fire(newValue)
    }
  }

  /// `Client` instance containing indices in which search will be performed
  public let client: SearchClient

  /// List of  index & query tuples
  public var indexQueryStates: [IndexQueryState] {
    didSet {
      let indexNameDiff = zip(oldValue.map(\.indexName), indexQueryStates.map(\.indexName)).enumerated()
      for (queryIndex, (oldIndexName, newIndexName)) in indexNameDiff where oldIndexName != newIndexName {
        onIndexChanged.fire((queryIndex, newIndexName))
      }
    }
  }

  public let isLoading: Observer<Bool>

  public let onQueryChanged: Observer<String?>

  public let onSearch: Observer<Void>

  public let onResults: Observer<SearchesResponse>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public let onError: Observer<([Query], Error)>

  /// Triggered when an index of a query changed
  /// - Parameter: a tuple of a index of query for which the indexName has changed and the new indexName
  public let onIndexChanged: Observer<(Int, String)>

  /// Custom request options
  public var requestOptions: RequestOptions?

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  /// Helpers for separate pagination management
  internal var pageLoaders: [PageLoaderProxy]

  /// Closure defining the condition under which the search operation should be triggered
  ///
  /// Example: if you don't want search operation triggering in case the query for the first index is empty, you should set this value
  /// ````
  /// shouldTriggerSearchForQueries = { queries in
  ///  queries.first?.query ?? "" != ""
  /// }
  /// ````
  /// - Default value: nil
  public var shouldTriggerSearchForQueries: (([Query]) -> Bool)?

  private let processingQueue: OperationQueue

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexNames: List of the indices names in which search will be performed
   - requestOptions: Custom request options. Default is nil.
   */
  public convenience init(appID: String,
                          apiKey: String,
                          indexNames: [String],
                          requestOptions: RequestOptions? = nil) {
    let client = try! SearchClient(appID: appID, apiKey: apiKey)
    let indexQueryStates = indexNames.map { IndexQueryState(indexName: $0, query: .init()) }
    self.init(client: client,
              indexQueryStates: indexQueryStates,
              requestOptions: requestOptions)
  }

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexNames: List of the indices names in which search will be performed
   - requestOptions: Custom request options. Default is `nil`.
   */

  public convenience init(client: SearchClient,
                          indices: [String],
                          requestOptions: RequestOptions? = nil) {
    let indexQueryStates = indices.map { IndexQueryState(indexName: $0, query: .init()) }
    self.init(client: client,
              indexQueryStates: indexQueryStates,
              requestOptions: requestOptions)
  }

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexQueryStates: List of the instances of IndexQueryStates encapsulating index value in which search will be performed and a correspondant Query instance
   - requestOptions: Custom request options. Default is nil.
   */

  public init(client: SearchClient,
              indexQueryStates: [IndexQueryState],
              requestOptions: RequestOptions? = nil) {
    self.client = client
    self.indexQueryStates = indexQueryStates
    self.requestOptions = requestOptions
    pageLoaders = []

    processingQueue = .init()
    sequencer = .init()
    onQueryChanged = .init()
    onIndexChanged = .init()
    isLoading = .init()
    onResults = .init()
    onError = .init()
    onSearch = .init()

    sequencer.delegate = self
    onResults.retainLastData = true
    isLoading.retainLastData = true
    updateClientUserAgents()
    processingQueue.maxConcurrentOperationCount = 1
    processingQueue.qualityOfService = .userInitiated

    pageLoaders = indexQueryStates.indices.map { [weak self] index in
      return PageLoaderProxy(setPage: { self?.indexQueryStates[index].query.page = $0 }, launchSearch: { self?.search() })
    }
  }

  public func search() {
    if let shouldTriggerSearch = shouldTriggerSearchForQueries, !shouldTriggerSearch(indexQueryStates.map(\.query)) {
      return
    }

    onSearch.fire(())

    let queries = indexQueryStates.map { IndexedQuery(indexName: $0.indexName, query: $0.query) }
    let searchQueries = queries.asSearchQueries()
    let searchParams = SearchMethodParams(queries: searchQueries)
    let requestOpts = requestOptions

    let operation = TaskAsyncOperation { [weak self] in
      guard let searcher = self else { return }
      do {
        let response: SearchesResponse = try await searcher.client.search(
          searchMethodParams: searchParams,
          requestOptions: requestOpts
        )
        searcher.processingQueue.addOperation {
          zip(queries, response.results)
            .forEach { query, searchResult in
              if let searchResponse = searchResult.asSearchResponse {
                InstantSearchCoreLog.Results.success(searcher: searcher, indexName: query.indexName, results: searchResponse)
              }
            }
          searcher.onResults.fire(response)
        }
      } catch {
        searcher.processingQueue.addOperation {
          let indicesDescriptor = "[\(queries.map { $0.indexName }.joined(separator: ", "))]"
          InstantSearchCoreLog.Results.failure(searcher: searcher, indexName: indicesDescriptor, error)
          searcher.onError.fire((queries.map { $0.query }, error))
        }
      }
    }
    operation.start()
    sequencer.orderOperation(operationLauncher: { return operation })
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }
}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
extension MultiIndexSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    self.query = query
  }
}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
internal extension MultiIndexSearcher {
  class PageLoaderProxy: PageLoadable {
    let setPage: (Int) -> Void
    let launchSearch: () -> Void

    init(setPage: @escaping (Int) -> Void, launchSearch: @escaping () -> Void) {
      self.setPage = setPage
      self.launchSearch = launchSearch
    }

    func loadPage(atIndex pageIndex: Int) {
      setPage(pageIndex)
      launchSearch()
    }
  }
}
