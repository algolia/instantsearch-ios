//
//  SingleIndexSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// An entity performing search queries targeting one index
final public class SingleIndexSearcher: IndexSearcher<AlgoliaSearchService> {

  public override var query: String? {

    get {
      return request.query.query
    }

    set {
      let oldValue = request.query.query
      guard oldValue != newValue else { return }
      cancel()
      request.query.query = newValue
      request.query.page = 0
      onQueryChanged.fire(newValue)
    }

  }

  public var client: SearchClient {
    return service.client
  }

  /// Current index & query tuple
  public var indexQueryState: IndexQueryState {
    get {
      return IndexQueryState(indexName: request.indexName, query: request.query)
    }

    set {
      self.request = .init(indexName: newValue.indexName, query: newValue.query)
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
  public var disjunctiveFacetsAttributes: Set<Attribute>

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
    self.disjunctiveFacetsAttributes = []
    let request = AlgoliaSearchService.Request(indexName: indexName, query: query, requestOptions: requestOptions)
    super.init(service: AlgoliaSearchService(client: client), initialRequest: request)
    self.requestOptions = requestOptions
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

}
