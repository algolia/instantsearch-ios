//
//  FacetSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

class FacetSearchService: SearchService, AlgoliaService {
  
  public struct Request: IndexProvider, TextualQueryProvider {
    public var query: String
    public var indexName: IndexName
    public var attribute: Attribute
    public var context: AlgoliaSearchClient.Query
    
    public var textualQuery: String? {
      get { query }
      set { query = newValue ?? "" }
    }
  }
  
  let client: SearchClient
  var requestOptions: RequestOptions?
  
  init(client: SearchClient) {
    self.client = client
  }

  func search(_ request: Request, completion: @escaping (Result<FacetSearchResponse, Error>) -> Void) -> Operation {
    return client.index(withName: request.indexName).searchForFacetValues(of: request.attribute, matching: request.query, applicableFor: request.context, requestOptions: requestOptions, completion: completion)
  }
  
}
