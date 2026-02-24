//
//  FacetSearchService.swift
//
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Core
import Foundation
import Search

public class FacetSearchService: SearchService {
  let client: SearchClient

  public init(client: SearchClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<FacetSearchResponse, Error>) -> Void) -> Operation {
    let operation = TaskAsyncOperation { [client] in
      do {
        let params = SearchParamsEncoder.encode(request.context)
        let searchRequest = SearchForFacetValuesRequest(params: params, facetQuery: request.query)
        let response = try await client.searchForFacetValues(
          indexName: request.indexName,
          facetName: request.attribute,
          searchForFacetValuesRequest: searchRequest,
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

public extension FacetSearchService {
  struct Request: IndexNameProvider, TextualQueryProvider, AlgoliaRequest {
    public var query: String
    public var indexName: String
    public var attribute: String
    public var context: Query
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get { query }
      set { query = newValue ?? "" }
    }

    public init(query: String,
                indexName: String,
                attribute: String,
                context: Query = .init(),
                requestOptions: RequestOptions? = nil) {
      self.query = query
      self.indexName = indexName
      self.attribute = attribute
      self.context = context
      self.requestOptions = requestOptions
    }
  }
}
