//
//  HitsSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import AlgoliaCore
#if !InstantSearchCocoaPods
import InstantSearchInsights
#endif
import Foundation
import AlgoliaSearch

@available(*, deprecated, renamed: "HitsSearcher")
public typealias SingleIndexSearcher = HitsSearcher

/// An entity performing hits search
public final class HitsSearcher: IndexSearcher<AlgoliaSearchService> {
  private struct NoopHitsAfterSearchTracker: HitsAfterSearchTrackable {
    func clickedAfterSearch(eventName: String,
                            indexName: String,
                            objectIDsWithPositions: [(String, Int)],
                            queryID: String,
                            timestamp: Date?,
                            userToken: String?) {}

    func convertedAfterSearch(eventName: String,
                              indexName: String,
                              objectIDs: [String],
                              queryID: String,
                              timestamp: Date?,
                              userToken: String?) {}

    func viewed(eventName: String,
                indexName: String,
                objectIDs: [String],
                timestamp: Date?,
                userToken: String?) {}
  }

  private var insightsCredentials: (appID: String, apiKey: String)?
  /// Current index & query tuple
  @available(*, deprecated, message: "Use the `request` property instead")
  public var indexQueryState: IndexQueryState {
    get {
      return IndexQueryState(indexName: request.indexName, query: request.query)
    }

    set {
      self.request = .init(indexName: newValue.indexName, query: newValue.query)
    }
  }

  override public var request: Request {
    didSet {
      guard request.query.query != oldValue.query.query || request.indexName != oldValue.indexName else { return }
      if request.query.page ?? 0 != 0 {
        request.query.page = 0
      }
    }
  }

  /// Custom request options
  public var requestOptions: RequestOptions? {
    get {
      request.requestOptions
    }

    set {
      request.requestOptions = newValue
    }
  }

  /// Delegate providing a necessary information for disjuncitve faceting
  public weak var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate? {
    get {
      service.disjunctiveFacetingDelegate
    }

    set {
      service.disjunctiveFacetingDelegate = newValue
    }
  }

  /// Delegate providing a necessary information for hierarchical faceting
  public weak var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate? {
    get {
      service.hierarchicalFacetingDelegate
    }

    set {
      service.hierarchicalFacetingDelegate = newValue
    }
  }

  /// Manually set attributes for disjunctive faceting
  ///
  /// These attributes are merged with disjunctiveFacetsAttributes provided by DisjunctiveFacetingDelegate to create the necessary queries for disjunctive faceting
  public var disjunctiveFacetsAttributes: Set<String> {
    get {
      service.disjunctiveFacetsAttributes
    }

    set {
      service.disjunctiveFacetsAttributes = newValue
    }
  }

  /// Flag defining if disjunctive faceting is enabled
  /// - Default value: true
  public var isDisjunctiveFacetingEnabled: Bool {
    get {
      service.isDisjunctiveFacetingEnabled
    }

    set {
      service.isDisjunctiveFacetingEnabled = newValue
    }
  }

  /// Flag defining if the selected query facet must be kept even if it does not match current results anymore
  /// - Default value: true
  public var keepSelectedEmptyFacets: Bool {
    get {
      service.keepSelectedEmptyFacets
    }

    set {
      service.keepSelectedEmptyFacets = newValue
    }
  }

  /// The hitsTracker property in the HitsSearcher class simplifies the tracking of Insights events for the search performed by the searcher.
  ///
  /// It is an instance of the HitsTracker class that provides methods for tracking clicks, conversions, and views for search results.
  /// By default, it uses the eventName property of the HitsSearcher instance as the event name to track, but custom event names can also be provided by passing them as parameters to the tracking methods.
  public lazy var eventTracker: HitsTracker = {
    let tracker: HitsAfterSearchTrackable
    if let shared = Insights.shared {
      tracker = shared
    } else if let credentials = insightsCredentials,
              let registered = try? Insights.register(appId: credentials.appID, apiKey: credentials.apiKey) {
      tracker = registered
    } else {
      tracker = NoopHitsAfterSearchTracker()
    }
    return HitsTracker(eventName: "hits event",
                       searcher: .singleIndex(self),
                       tracker: tracker)
  }()

  /**
    - Parameters:
       - appID: Application ID
       - apiKey: API Key
       - indexName: Name of the index in which search will be performed
       - query: Instance of Query. By default a new empty instant of Query will be created.
       - isAutoSendingHitsViewEvents: flag defining whether the automatic hits view Insights events sending is enabled
       - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: String,
                          apiKey: String,
                          indexName: String,
                          query: SearchSearchParamsObject = .init(),
                          requestOptions: RequestOptions? = nil,
                          isAutoSendingHitsViewEvents: Bool = false) throws {
    let client = try AlgoliaSearch.SearchClient(appID: appID, apiKey: apiKey)
    self.init(client: client, indexName: indexName, query: query, requestOptions: requestOptions, isAutoSendingHitsViewEvents: isAutoSendingHitsViewEvents)
    insightsCredentials = (appID: appID, apiKey: apiKey)
    Telemetry.shared.trace(type: .hitsSearcher,
                           parameters: [
                             .appID,
                             .apiKey
                           ])
  }

  /**
    - Parameters:
       - index: Index value in which search will be performed
       - query: Instance of Query. By default a new empty instant of Query will be created.
       - isAutoSendingHitsViewEvents: flag defining whether the automatic hits view Insights events sending is enabled
       - requestOptions: Custom request options. Default is nil.
   */
  public init(client: AlgoliaSearch.SearchClient,
              indexName: String,
              query: SearchSearchParamsObject = .init(),
              requestOptions: RequestOptions? = nil,
              isAutoSendingHitsViewEvents: Bool = false) {
    let service = AlgoliaSearchService(client: client)
    let request = AlgoliaSearchService.Request(indexName: indexName, query: query, requestOptions: requestOptions)
    super.init(service: service, initialRequest: request)
    Telemetry.shared.trace(type: .hitsSearcher,
                           parameters: .client)
    insightsCredentials = (appID: client.configuration.appID, apiKey: client.configuration.apiKey)
    onResults.subscribe(with: self) { searcher, response in
        if isAutoSendingHitsViewEvents {
            searcher.eventTracker.trackView(for: response.hits, eventName: "Hits Viewed")
        }
    }
  }

  /**
   - Parameters:
      - indexQueryState: Instance of `IndexQueryState` encapsulating index value in which search will be performed and a `Query` instance.
      - isAutoSendingHitsViewEvents: flag defining whether the automatic hits view Insights events sending is enabled
      - requestOptions: Custom request options. Default is nil.
   */
  public convenience init(client: AlgoliaSearch.SearchClient,
                          indexQueryState: IndexQueryState,
                          requestOptions: RequestOptions? = nil,
                          isAutoSendingHitsViewEvents: Bool = false) {
    self.init(client: client,
              indexName: indexQueryState.indexName,
              query: indexQueryState.query,
              requestOptions: requestOptions,
              isAutoSendingHitsViewEvents: isAutoSendingHitsViewEvents
    )
  }

  deinit {
    onResults.cancelSubscription(for: self)
  }
}

extension HitsSearcher: MultiSearchComponent {
  public typealias SubRequest = SearchQuery
  public typealias SubResult = AlgoliaSearch.SearchResult<Hit<[String: AlgoliaCore.AnyCodable]>>

  public func collect() -> (requests: [SearchQuery], completion: (Swift.Result<[AlgoliaSearch.SearchResult<SearchHit>], Swift.Error>) -> Void) {
    return service.collect(for: request) { [weak self] result in
      guard let searcher = self else { return }
      switch result {
      case let .failure(error):
        searcher.onError.fire(error)
      case let .success(response):
        searcher.onResults.fire(response)
      }
    }
  }
}

extension HitsSearcher: QuerySettable {
  public func setQuery(_ query: String?) {
    request.query.query = query
    request.query.page = 0
  }
}

extension HitsSearcher: IndexNameSettable {
  public func setIndexName(_ indexName: String) {
    request.indexName = indexName
    request.query.page = 0
  }
}

extension HitsSearcher: FiltersSettable {
  public func setFilters(_ filters: String?) {
    request.query.filters = filters
    request.query.page = 0
  }
}
