//
//  AlgoliaPlacesSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

public class AlgoliaPlacesSearchService: SearchService {

  let client: PlacesClient

  init(client: PlacesClient) {
    self.client = client
  }

  public func search(_ request: Request, completion: @escaping (Result<PlacesClient.SingleLanguageResponse, Error>) -> Void) -> Operation {
    return client.search(query: request.query, language: request.language, requestOptions: request.requestOptions, completion: completion)
  }

}

extension AlgoliaPlacesSearchService {

  public struct Request: TextualQueryProvider, AlgoliaRequest {

    public var query: PlacesQuery
    public var language: Language
    public var requestOptions: RequestOptions?

    public var textualQuery: String? {
      get {
        return query.query
      }
      set {
        query.query = newValue
      }
    }

    public init(query: PlacesQuery, language: Language) {
      self.query = query
      self.language = language
    }

  }

}
