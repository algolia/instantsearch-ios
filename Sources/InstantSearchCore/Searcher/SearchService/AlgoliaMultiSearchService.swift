//
//  AlgoliaMultiSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation
import AlgoliaSearchClient

public class AlgoliaMultiSearchService: MultiSearchService {

  public let client: SearchClient

  public init(client: SearchClient) {
    self.client = client
  }

  public convenience init(appID: ApplicationID, apiKey: APIKey) {
    self.init(client: .init(appID: appID, apiKey: apiKey))
  }

  public func search(_ request: Request, completion: @escaping (Swift.Result<CompoundSearchResponse, Error>) -> Void) -> Operation {
    return client.search(queries: request.queries,
                         strategy: request.strategy,
                         requestOptions: request.requestOptions,
                         completion: completion)
  }

}

extension AlgoliaMultiSearchService {

  public struct Request: AlgoliaRequest, MultiRequest {

    public typealias SubRequest = IndexedQuery

    public var subRequests: [IndexedQuery] {
      get {
        return queries
      }

      set {
        self.queries = newValue
      }
    }

    public var queries: [IndexedQuery]
    public var strategy: MultipleQueriesStrategy
    public var requestOptions: RequestOptions?

    public init(queries: [IndexedQuery],
                strategy: MultipleQueriesStrategy,
                requestOptions: RequestOptions? = nil) {
      self.queries = queries
      self.strategy = strategy
      self.requestOptions = requestOptions
    }

  }

}

extension CompoundSearchResponse: MultiResult {

  public var subResults: [Response] {
    return results
  }

}
