//
//  AlgoliaAnswersSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

@available(*, deprecated, message: "Answers feature is deprecated")
public final class AlgoliaAnswersSearchService: SearchService {

  public let client: SearchClient

  public init(client: SearchClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    return client.index(withName: request.indexName).findAnswers(for: request.query, requestOptions: request.requestOptions, completion: completion)
  }

}

@available(*, deprecated, message: "Answers feature is deprecated")
extension AlgoliaAnswersSearchService {

  public struct Request: IndexNameProvider, TextualQueryProvider, AlgoliaRequest {

    public var indexName: IndexName
    public var query: AnswersQuery
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get {
        let textualQuery = query.query
        return textualQuery
      }

      set {
        let textualQueryToSet = newValue ?? ""
        query.query = textualQueryToSet
      }
    }

    public init(indexName: IndexName, query: AnswersQuery, requestOptions: RequestOptions? = nil) {
      self.indexName = indexName
      self.query = query
      self.requestOptions = requestOptions
    }
  }

}
