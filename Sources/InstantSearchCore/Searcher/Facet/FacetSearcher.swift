//
//  FacetSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
/** An entity performing search for facet values
 */

public class FacetSearcher: Searcher, SequencerDelegate, SearchResultObservable {

  public typealias SearchResult = FacetSearchResponse

  public var query: String? {
    didSet {
      guard oldValue != query else { return }
      onQueryChanged.fire(query)
    }
  }

  public let client: SearchClient

  /// Current tuple of index and query
  public var indexQueryState: IndexQueryState

  public let isLoading: Observer<Bool>

  public var onQueryChanged: Observer<String?>

  public let onSearch: Observer<Void>

  public let onResults: Observer<SearchResult>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query text and error
  public let onError: Observer<(String, Error)>

  /// Name of facet attribute for which the values will be searched
  public var facetName: String

  /// Custom request options
  public var requestOptions: RequestOptions?

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  private let processingQueue: OperationQueue

  /**
   - Parameters:
   - appID: Application ID
   - apiKey: API Key
   - indexName: Name of the index in which search will be performed
   - facetName: Name of facet attribute for which the values will be searched
   - query: Instance of Query. By default a new empty instant of Query will be created.
   - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName,
                          facetName: String,
                          query: Query = .init(),
                          requestOptions: RequestOptions? = nil) {
    let client = SearchClient(appID: appID, apiKey: apiKey)
    self.init(client: client,
              indexName: indexName,
              facetName: facetName,
              query: query,
              requestOptions: requestOptions)
    updateClientUserAgents()
  }

  /**
   - Parameters:
   - index: Index value in which search will be performed
   - facetName: Name of facet attribute for which the values will be searched
   - query: Instance of Query. By default a new empty instant of Query will be created.
   - requestOptions: Custom request options. Default is `nil`.
   */
  public init(client: SearchClient,
              indexName: IndexName,
              facetName: String,
              query: Query = .init(),
              requestOptions: RequestOptions? = nil) {
    self.client = client
    self.indexQueryState = IndexQueryState(indexName: indexName, query: query)
    self.isLoading = .init()
    self.onQueryChanged = .init()
    self.onResults = .init()
    self.onError = .init()
    self.onSearch = .init()
    self.facetName = facetName
    self.sequencer = .init()
    self.processingQueue = .init()
    self.requestOptions = requestOptions
    sequencer.delegate = self
    onResults.retainLastData = true
    isLoading.retainLastData = true
    processingQueue.maxConcurrentOperationCount = 1
    processingQueue.qualityOfService = .userInitiated
  }

  public func search() {

    onSearch.fire(())

    let query = self.query ?? ""
    let indexName = indexQueryState.indexName

    let operation = client.index(withName: indexName).searchForFacetValues(of: Attribute(rawValue: facetName), matching: query, applicableFor: indexQueryState.query) { [weak self] result in
      guard let searcher = self else { return }

      searcher.processingQueue.addOperation {
        switch result {
        case .success(let results):
          InstantSearchCoreLogger.Results.success(searcher: searcher, indexName: indexName, results: results)
          searcher.onResults.fire(results)

        case .failure(let error):
          InstantSearchCoreLogger.Results.failure(searcher: searcher, indexName: indexName, error)
          searcher.onError.fire((query, error))
        }
      }
    }

    sequencer.orderOperation(operationLauncher: { return operation })

  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }

}
