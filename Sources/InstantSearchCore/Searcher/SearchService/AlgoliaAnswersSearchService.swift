//
//  AlgoliaAnswersSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaAnswersSearchService: SearchService {
  
  let client: SearchClient
  
  init(client: SearchClient) {
    self.client = client
  }
  
  public func search(_ request: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    return client.index(withName: request.indexName).findAnswers(for: request.query, requestOptions: request.requestOptions, completion: completion)
  }
  
}

extension AlgoliaAnswersSearchService {
  
  public struct Request: IndexProvider, TextualQueryProvider, AlgoliaRequest {
    
    public var indexName: IndexName
    public var query: AnswersQuery
    public var requestOptions: RequestOptions?
    
    public var textualQuery: String? {
      get {
        return query.query
      }
      
      set {
        query.query = newValue
      }
    }
    
    public init(indexName: IndexName, query: AnswersQuery, requestOptions: RequestOptions? = nil) {
      self.indexName = indexName
      self.query = query
      self.requestOptions = requestOptions
    }
  }
  
}
