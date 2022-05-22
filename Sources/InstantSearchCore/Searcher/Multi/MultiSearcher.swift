//
//  MultiSearcher.swift
//  
//
//  Created by Vladislav Fitc on 29/09/2021.
//

import Foundation
import AlgoliaSearchClient

/// Searcher performing search for hits or facets in multiple indices simultaneously
public class MultiSearcher: AbstractMultiSearcher<AlgoliaMultiSearchService> {

  /**
   - Parameters:
      - client: Algolia search client
  */
  public convenience init(client: SearchClient) {
    let service = AlgoliaMultiSearchService(client: client)
    let initialRequest = Request(queries: [],
                                 strategy: .none,
                                 requestOptions: .none)
    self.init(service: service,
              initialRequest: initialRequest)
    Telemetry.shared.trace(type: .multiSearcher)
  }

  /**
   - Parameters:
      - appID: Application ID
      - apiKey: API Key
  */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey) {
    let client = SearchClient(appID: appID, apiKey: apiKey)
    self.init(client: client)
  }

  /**
   - Parameters:
       - indexName: Name of the index in which search will be performed
       - query: Instance of Query. By default a new empty instant of Query will be created.
       - requestOptions: Custom request options. Default is `nil`.
  */
  @discardableResult public func addHitsSearcher(indexName: IndexName,
                                                 query: Query = .init(),
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
       - requestOptions: Custom request options. Default is `nil`.
   */
  @discardableResult public func addFacetsSearcher(indexName: IndexName,
                                                   query: Query = .init(),
                                                   attribute: Attribute,
                                                   facetQuery: String = "",
                                                   requestOptions: RequestOptions? = nil) -> FacetSearcher {
    let searcher = FacetSearcher(client: service.client,
                                 indexName: indexName,
                                 facetName: attribute,
                                 query: query,
                                 requestOptions: requestOptions)
    return addSearcher(searcher)
  }

}
