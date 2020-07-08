//
//  MultiIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
/** An entity performing search queries targeting multiple indices.
*/

public class MultiIndexSearcher: Searcher, SequencerDelegate, SearchResultObservable {

  public var query: String? {

    set {
      let oldValue = indexQueryStates.first?.query.query
      guard oldValue != newValue else { return }
      self.indexQueryStates = indexQueryStates.map { indexQueryState in
        let query = indexQueryState.query.set(\.query, to: newValue).set(\.page, to: 0)
        return indexQueryState.set(\.query, to: query)
      }
      onQueryChanged.fire(newValue)
    }

    get {
      return indexQueryStates.first?.query.query
    }

  }

  /// `Client` instance containing indices in which search will be performed
  public let client: SearchClient

  /// List of  index & query tuples
  public internal(set) var indexQueryStates: [IndexQueryState]

  public let isLoading: Observer<Bool>

  public let onQueryChanged: Observer<String?>

  public let onResults: Observer<SearchesResponse>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public let onError: Observer<([Query], Error)>

  /// Custom request options
  public var requestOptions: RequestOptions?

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  /// Helpers for separate pagination management
  internal var pageLoaders: [PageLoaderProxy]

  private let processingQueue: OperationQueue

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexNames: List of the indices names in which search will be performed
   - requestOptions: Custom request options. Default is nil.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          indexNames: [IndexName],
                          requestOptions: RequestOptions? = nil) {
    let client = SearchClient(appID: appID, apiKey: apiKey)
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
                          indices: [Index],
                          requestOptions: RequestOptions? = nil) {
    let indexQueryStates = indices.map { IndexQueryState(indexName: $0.name, query: .init()) }
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
    self.pageLoaders = []

    processingQueue = .init()
    sequencer = .init()
    onQueryChanged = .init()
    isLoading = .init()
    onResults = .init()
    onError = .init()

    sequencer.delegate = self
    onResults.retainLastData = true
    isLoading.retainLastData = true
    updateClientUserAgents()
    processingQueue.maxConcurrentOperationCount = 1
    processingQueue.qualityOfService = .userInitiated

    self.pageLoaders = indexQueryStates.enumerated().map { (index, _) in
      return PageLoaderProxy(setPage: { self.indexQueryStates[index].query.page = $0 }, launchSearch: self.search)
    }

  }

  public func search() {

    let queries = indexQueryStates.map { IndexedQuery(indexName: $0.indexName, query: $0.query) }

    let operation = client.multipleQueries(queries: queries) { [weak self] result in
      guard let searcher = self else { return }
      searcher.processingQueue.addOperation {
        switch result {
        case .success(let response):
          zip(queries, response.results)
            .forEach { (query, searchResults) in
              Logger.Results.success(searcher: searcher, indexName: query.indexName, results: searchResults)
            }
          searcher.onResults.fire(response)

        case .failure(let error):
          let indicesDescriptor = "[\(queries.map { $0.indexName.rawValue }.joined(separator: ", "))]"
          Logger.Results.failure(searcher: searcher, indexName: IndexName(rawValue: indicesDescriptor), error)
          searcher.onError.fire((queries.map { $0.query }, error))
        }
      }
    }

    sequencer.orderOperation(operationLauncher: { return operation })
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }

}

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
