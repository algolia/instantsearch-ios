//
//  HitsSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import AlgoliaSearchClient
import InstantSearchInsights
import Foundation

@available(*, deprecated, renamed: "HitsSearcher")
public typealias SingleIndexSearcher = HitsSearcher

/// An entity performing hits search
public final class HitsSearcher: IndexSearcher<AlgoliaSearchService> {
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
  public var disjunctiveFacetsAttributes: Set<Attribute> {
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
    let client = service.client
    let insights = Insights.register(appId: client.applicationID,
                                     apiKey: client.apiKey)
    return HitsTracker(eventName: "hits event",
                       searcher: self,
                       insights: insights)
  }()

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
       - requestOptions: Custom request options. Default is nil.
   */
  public init(client: SearchClient,
              indexName: IndexName,
              query: Query = .init(),
              requestOptions: RequestOptions? = nil) {
    let service = AlgoliaSearchService(client: client)
    let request = AlgoliaSearchService.Request(indexName: indexName, query: query, requestOptions: requestOptions)
    super.init(service: service, initialRequest: request)
    Telemetry.shared.trace(type: .hitsSearcher,
                           parameters: .client)
    onResults.subscribe(with: self) { searcher, response in
      searcher.eventTracker.trackView(for: response.hits,
                                     eventName: "Hits Viewed")
    }
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

  deinit {
    onResults.cancelSubscription(for: self)
  }
}

extension HitsSearcher: MultiSearchComponent {
  public func collect() -> (requests: [MultiSearchQuery], completion: (Swift.Result<[MultiSearchResponse.Response], Swift.Error>) -> Void) {
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
  public func setIndexName(_ indexName: IndexName) {
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
