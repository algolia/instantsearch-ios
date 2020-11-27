//
//  AlgoliaMultiIndexSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaMultiIndexSearchService: SearchService, AlgoliaService {
  
  let client: SearchClient
  public var requestOptions: RequestOptions?

  init(client: SearchClient) {
    self.client = client
  }

  public func search(_ query: [IndexedQuery], completion: @escaping (Result<SearchesResponse, Error>) -> Void) -> Operation {
    return client.multipleQueries(queries: query, requestOptions: requestOptions, completion: completion)
  }
  
}
