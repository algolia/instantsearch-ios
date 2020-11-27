//
//  PlacesSearchService.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

class PlacesSearchService: SearchService, AlgoliaService {
  
  let client: PlacesClient
  var language: Language
  var requestOptions: RequestOptions?

  init(client: PlacesClient, language: Language = .english) {
    self.client = client
    self.language = language
  }
  
  func search(_ query: PlacesQuery, completion: @escaping (Result<PlacesClient.SingleLanguageResponse, Error>) -> Void) -> Operation {
    return client.search(query: query, language: language, requestOptions: requestOptions, completion: completion)
  }
  
}

