//
//  FacetSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class FacetSearchService: SearchService {

  let client: SearchClient

  public init(client: SearchClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<FacetSearchResponse, Error>) -> Void) -> Operation {
    return client
      .index(withName: request.indexName)
      .searchForFacetValues(of: request.attribute,
                            matching: request.query,
                            applicableFor: request.context,
                            requestOptions: request.requestOptions,
                            completion: completion)
  }

}

extension FacetSearchService {

  public struct Request: IndexNameProvider, TextualQueryProvider, AlgoliaRequest {

    public var query: String
    public var indexName: IndexName
    public var attribute: Attribute
    public var context: AlgoliaSearchClient.Query
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get { query }
      set { query = newValue ?? "" }
    }

    public init(query: String,
                indexName: IndexName,
                attribute: Attribute,
                context: Query,
                requestOptions: RequestOptions? = nil) {
      self.query = query
      self.indexName = indexName
      self.attribute = attribute
      self.context = context
      self.requestOptions = requestOptions
    }

  }

}
