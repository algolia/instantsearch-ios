//
//  AlgoliaAnswersSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaAnswersSearchService: SearchService, AlgoliaService {
  
  public struct Request: IndexProvider {
    public var indexName: IndexName
    public var query: AnswersQuery
  }
  
  let client: SearchClient
  public var requestOptions: RequestOptions?
  
  init(client: SearchClient) {
    self.client = client
  }
  
  public func search(_ query: Request, completion: @escaping (Result<SearchResponse, Error>) -> Void) -> Operation {
    return client.index(withName: query.indexName).findAnswers(for: query.query, requestOptions: requestOptions, completion: completion)
  }
  
}
