//
//  AlgoliaMultiIndexSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaMultiIndexSearchService: SearchService {

  let client: SearchClient

  init(client: SearchClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchesResponse, Error>) -> Void) -> Operation {
    return client.multipleQueries(queries: request.indexedQueries, requestOptions: request.requestOptions, completion: completion)
  }

}

extension AlgoliaMultiIndexSearchService {

  public struct Request: TextualQueryProvider, AlgoliaRequest {

    public var textualQuery: String? {
      get {
        return indexedQueries.first?.query.query
      }

      set {
        let oldValue = indexedQueries.first?.query.query
        guard oldValue != newValue else { return }
        self.indexedQueries = indexedQueries.map { indexedQuery in
          let updatedQuery = indexedQuery.query.set(\.query, to: newValue).set(\.page, to: 0)
          return .init(indexName: indexedQuery.indexName, query: updatedQuery)
        }
      }
    }

    public var indexedQueries: [IndexedQuery]
    public var requestOptions: RequestOptions?

    public init(indexedQueries: [IndexedQuery], requestOptions: RequestOptions? = nil) {
      self.indexedQueries = indexedQueries
      self.requestOptions = requestOptions
    }

  }

}
