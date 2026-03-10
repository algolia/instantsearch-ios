//
//  AlgoliaMultiSearchService.swift
//
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import AlgoliaCore
import Foundation
import AlgoliaSearch

public class AlgoliaMultiSearchService: MultiSearchService {
  public let client: AlgoliaSearch.SearchClient

  public init(client: AlgoliaSearch.SearchClient) {
    self.client = client
  }

  public convenience init(appID: String, apiKey: String) throws {
    self.init(client: try AlgoliaSearch.SearchClient(appID: appID, apiKey: apiKey))
  }

  public func search(_ request: Request, completion: @escaping (Swift.Result<AlgoliaSearch.SearchResponses<SearchHit>, Error>) -> Void) -> Operation {
    let operation = TaskAsyncOperation { [client] in
      do {
        let response: AlgoliaSearch.SearchResponses<SearchHit> = try await client.search(
          searchMethodParams: SearchMethodParams(queries: request.queries, strategy: request.strategy),
          requestOptions: request.requestOptions
        )
        completion(.success(response))
      } catch {
        completion(.failure(error))
      }
    }
    operation.start()
    return operation
  }
}

public extension AlgoliaMultiSearchService {
  struct Request: AlgoliaRequest, MultiRequest {
    public var subRequests: [SearchQuery] {
      get {
        return queries
      }

      set {
        queries = newValue
      }
    }

    public var queries: [SearchQuery]
    public var strategy: MultipleQueriesStrategy
    public var requestOptions: RequestOptions?

    public init(queries: [SearchQuery],
                strategy: MultipleQueriesStrategy,
                requestOptions: RequestOptions? = nil) {
      self.queries = queries
      self.strategy = strategy
      self.requestOptions = requestOptions
    }
  }
}

extension AlgoliaSearch.SearchResponses: MultiResult {
  public var subResults: [SearchResult<T>] {
    return results
  }
}
