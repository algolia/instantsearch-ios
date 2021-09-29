//
//  MultiSearcher+Algolia.swift
//  
//
//  Created by Vladislav Fitc on 29/09/2021.
//

import Foundation

public extension MultiSearcher where Service == AlgoliaMultiSearchService {

  convenience init(appID: ApplicationID,
                   apiKey: APIKey) {
    let service = AlgoliaMultiSearchService(appID: appID,
                                                apiKey: apiKey)
    let initialRequest = Request(queries: [],
                                 strategy: .none,
                                 requestOptions: .none)
    self.init(service: service,
              initialRequest: initialRequest)
  }

  @discardableResult func addHitsSearcher(indexName: IndexName,
                                          query: Query = .init(),
                                          requestOptions: RequestOptions? = nil) -> HitsSearcher {
    let searcher = HitsSearcher(client: service.client,
                                indexName: indexName,
                                query: query,
                                requestOptions: requestOptions)
    return addSearcher(searcher)
  }

  @discardableResult func addFacetsSearcher(indexName: IndexName,
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

