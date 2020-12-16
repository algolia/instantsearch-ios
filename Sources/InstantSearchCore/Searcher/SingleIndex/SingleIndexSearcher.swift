//
//  SingleIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable function_body_length

import Foundation
import AlgoliaSearchClient

/// An entity performing search queries targeting one index

public class SingleIndexSearcher: Searcher, SequencerDelegate, SearchResultObservable {

  public var query: String? {

    get {
      return indexQueryState.query.query
    }

    set {
      let oldValue = indexQueryState.query.query
      guard oldValue != newValue else { return }
      cancel()
      indexQueryState.query.query = newValue
      indexQueryState.query.page = 0
      onQueryChanged.fire(newValue)
    }

  }

  public let client: SearchClient

  /// Current index & query tuple
  public var indexQueryState: IndexQueryState {
    didSet {
      if oldValue.indexName != indexQueryState.indexName {
        onIndexChanged.fire(indexQueryState.indexName)
      }
    }
  }

  public let isLoading: Observer<Bool>

  public let onQueryChanged: Observer<String?>

  public let onSearch: Observer<Void>

  public let onResults: Observer<SearchResponse>

  /// Triggered when an error occured during search query execution
  /// - Parameter: a tuple of query and error
  public let onError: Observer<(Query, Error)>

  /// Triggered when an index of Searcher changed
  /// - Parameter: equals to a new index value
  public let onIndexChanged: Observer<IndexName>

  /// Custom request options
  public var requestOptions: RequestOptions?

  /// Delegate providing a necessary information for disjuncitve faceting
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate?

  /// Delegate providing a necessary information for hierarchical faceting
  public weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate?

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with disjunctiveFacetsAttributes provided by DisjunctiveFacetingDelegate to create the necessary queries for disjunctive faceting
  public var disjunctiveFacetsAttributes: Set<Attribute>

  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  public var isDisjunctiveFacetingEnabled = true

  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  public var keepSelectedEmptyFacets: Bool = true

  /// Closure defining the condition under which the search operation should be triggered
  ///
  /// Example: if you don't want search operation triggering in case of empty query, you should set this value
  /// ````
  /// searcher.shouldTriggerSearchForQuery = { query in query.query ?? "" != "" }
  /// ````
  /// - Default value: nil
  public var shouldTriggerSearchForQuery: ((Query) -> Bool)?

  /// Sequencer which orders and debounce redundant search operations
  internal let sequencer: Sequencer

  private let processingQueue: OperationQueue

  /**
   - Parameters:
      - appID: Application ID
      - apiKey: API Key
      - indexName: Name of the index in which search will be performed
      - query: Instance of Query. By default a new empty instant of Query will be created.
      - requestOptions: Custom request options. Default is `nil`.
  */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName,
                          query: Query = .init(),
                          requestOptions: RequestOptions? = nil) {
    let client = SearchClient(appID: appID, apiKey: apiKey)
    self.init(client: client, indexName: indexName, query: query, requestOptions: requestOptions)
  }

  /**
   - Parameters:
      - index: Index value in which search will be performed
      - query: Instance of Query. By default a new empty instant of Query will be created.
      - requestOptions: Custom request options. Default is nil.
  */
  public init(client: SearchClient,
              indexName: IndexName,
              query: Query = .init(),
              requestOptions: RequestOptions? = nil) {
    self.client = client
    indexQueryState = .init(indexName: indexName, query: query)
    self.requestOptions = requestOptions
    sequencer = .init()
    isLoading = .init()
    onResults = .init()
    onError = .init()
    onQueryChanged = .init()
    onIndexChanged = .init()
    processingQueue = .init()
    onSearch = .init()
    disjunctiveFacetsAttributes = []
    sequencer.delegate = self
    onResults.retainLastData = true
    onError.retainLastData = false
    isLoading.retainLastData = true
    updateClientUserAgents()
    processingQueue.maxConcurrentOperationCount = 1
    processingQueue.qualityOfService = .userInitiated
  }

  /**
   - Parameters:
      - indexQueryState: Instance of `IndexQueryState` encapsulating index value in which search will be performed and a `Query` instance.
      - requestOptions: Custom request options. Default is nil.
   */
  public convenience init(client: SearchClient,
                          indexQueryState: IndexQueryState,
                          requestOptions: RequestOptions? = nil) {
    self.init(client: client,
              indexName: indexQueryState.indexName,
              query: indexQueryState.query,
              requestOptions: requestOptions)
  }

  public func search() {

    if let shouldTriggerSearch = shouldTriggerSearchForQuery, !shouldTriggerSearch(indexQueryState.query) {
      return
    }

    onSearch.fire(())

    let query = indexQueryState.query

    let operation: Operation

    if isDisjunctiveFacetingEnabled {
      let disjunctiveFacets = disjunctiveFacetsAttributes.union(disjunctiveFacetingDelegate?.disjunctiveFacetsAttributes ?? [])
      let filterGroups = disjunctiveFacetingDelegate?.toFilterGroups() ?? []
      let hierarchicalAttributes = hierarchicalFacetingDelegate?.hierarchicalAttributes ?? []
      let hierarchicalFilters = hierarchicalFacetingDelegate?.hierarchicalFilters ?? []
      var queriesBuilder = QueryBuilder(query: query,
                                        disjunctiveFacets: disjunctiveFacets,
                                        filterGroups: filterGroups,
                                        hierarchicalAttributes: hierarchicalAttributes,
                                        hierachicalFilters: hierarchicalFilters)
      queriesBuilder.keepSelectedEmptyFacets = keepSelectedEmptyFacets
      let queries = queriesBuilder.build().map { IndexedQuery(indexName: indexQueryState.indexName, query: $0) }
      operation = client.multipleQueries(queries: queries) { [weak self] response in
        guard let searcher = self else { return }

        searcher.processingQueue.addOperation {
            let indexName = searcher.indexQueryState.indexName

            switch response {
            case .failure(let error):
              InstantSearchCoreLogger.Results.failure(searcher: searcher, indexName: indexName, error)
              searcher.onError.fire((queriesBuilder.query, error))

            case .success(let results):
              do {
                let result = try queriesBuilder.aggregate(results.results)
                InstantSearchCoreLogger.Results.success(searcher: searcher, indexName: indexName, results: result)
                searcher.onResults.fire(result)
              } catch let error {
                InstantSearchCoreLogger.Results.failure(searcher: searcher, indexName: indexName, error)
                searcher.onError.fire((queriesBuilder.query, error))
              }
            }
        }
      }
    } else {
      operation = client.index(withName: indexQueryState.indexName).search(query: query, requestOptions: requestOptions) { [weak self] result in
        guard let searcher = self, searcher.query == query.query else { return }
        searcher.processingQueue.addOperation {
          let indexName = searcher.indexQueryState.indexName

          switch result {
          case .failure(let error):
            InstantSearchCoreLogger.Results.failure(searcher: searcher, indexName: indexName, error)
            searcher.onError.fire((query, error))

          case .success(let results):
            InstantSearchCoreLogger.Results.success(searcher: searcher, indexName: indexName, results: results)
            searcher.onResults.fire(results)
          }
        }
      }
    }

    sequencer.orderOperation(operationLauncher: { return operation })
  }

  public func cancel() {
    sequencer.cancelPendingOperations()
  }

}
