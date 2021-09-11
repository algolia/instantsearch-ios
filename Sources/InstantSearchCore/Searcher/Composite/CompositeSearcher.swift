//
//  CompositeSearcher.swift
//  
//
//  Created by Vladislav Fitc on 08/09/2021.
//

import Foundation

public typealias CompositeSearcher = AbstractCompositeSearcher<SearchClient>

public extension CompositeSearcher {

  convenience init(appID: ApplicationID, apiKey: APIKey) {
    self.init(service: .init(appID: appID, apiKey: apiKey), initialRequest: [])
  }

  @discardableResult func addHitsSearcher(indexName: IndexName,
                                          query: Query = .init(),
                                          requestOptions: RequestOptions? = nil) -> HitsSearcher {
    let searcher = HitsSearcher(client: service,
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
    let searcher = FacetSearcher(client: service,
                                 indexName: indexName,
                                 facetName: attribute,
                                 query: query,
                                 requestOptions: requestOptions)
    return addSearcher(searcher)
  }

}
