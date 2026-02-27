//
//  MultiSearcher.swift
//
//
//  Created by Vladislav Fitc on 29/09/2021.
//

import Core
import Foundation
import Search

/// Searcher performing search for hits or facets in multiple indices simultaneously
public class MultiSearcher: AbstractMultiSearcher<AlgoliaMultiSearchService> {
  /**
    - Parameters:
       - client: Algolia search client
   */
  @available(*, deprecated, message: "Use init(client:requestOptions:) instead")
  public convenience init(client: SearchClient) {
      self.init(client: client, requestOptions: nil)
  }

  /**
    - Parameters:
       - client: Algolia search client
       - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(client: SearchClient, requestOptions: RequestOptions? = nil) {
    let service = AlgoliaMultiSearchService(client: client)
    let initialRequest = Request(queries: [],
                                 strategy: .none,
                                 requestOptions: requestOptions)
    self.init(service: service,
              initialRequest: initialRequest)
    Telemetry.shared.trace(type: .multiSearcher)
  }

  /**
    - Parameters:
       - appID: Application ID
       - apiKey: API Key
   */
  @available(*, deprecated, message: "Use init(appID:apiKey:requestOptions:) instead")
  public convenience init(appID: String,
                          apiKey: String) {
    self.init(appID: appID, apiKey: apiKey, requestOptions: nil)
  }

  /**
    - Parameters:
       - appID: Application ID
       - apiKey: API Key
       - requestOptions: Custom request options. Default is `nil`.
   */
  public convenience init(appID: String,
                          apiKey: String,
                          requestOptions: RequestOptions? = nil) {
    // swiftlint:disable:next force_try
    let client = try! SearchClient(appID: appID, apiKey: apiKey)
    self.init(client: client, requestOptions: requestOptions)
  }

  /**
    - Parameters:
        - indexName: Name of the index in which search will be performed
        - query: Instance of Query. By default a new empty instant of Query will be created.
        - requestOptions: requestOptions: Deprecated: This option does not have an effect, use `requestOptions` in `init` instead.
   */
  @discardableResult public func addHitsSearcher(indexName: String,
                                                 query: SearchSearchParamsObject = .init(),
                                                 requestOptions: RequestOptions? = nil) -> HitsSearcher {
    let searcher = HitsSearcher(client: service.client,
                                indexName: indexName,
                                query: query,
                                requestOptions: requestOptions)
    return addSearcher(searcher)
  }

  /**
   - Parameters:
       - indexName: Name of the index in which search will be performed
       - query: Instance of Query. By default a new empty instant of Query will be created.
       - attribute: Name of facet attribute for which the values will be searched
       - facetQuery: Initial facet search query
       - requestOptions: requestOptions: Deprecated: This option does not have an effect, use `requestOptions` in `init` instead.
   */
  @discardableResult public func addFacetsSearcher(indexName: String,
                                                   query: SearchSearchParamsObject = .init(),
                                                   attribute: String,
                                                   facetQuery _: String = "",
                                                   requestOptions: RequestOptions? = nil) -> FacetSearcher {
    let searcher = FacetSearcher(client: service.client,
                                 indexName: indexName,
                                 facetName: attribute,
                                 query: query,
                                 requestOptions: requestOptions)
    return addSearcher(searcher)
  }
}
