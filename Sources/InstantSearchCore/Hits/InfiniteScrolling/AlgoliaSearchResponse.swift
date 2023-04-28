//
//  AlgoliaSearchResponse.swift
//  
//
//  Created by Vladislav Fitc on 28/04/2023.
//

import Foundation

public class AlgoliaSearchResponse<Hit: Decodable> {
    
  /// The Algolia search response object.
  public let searchResponse: AlgoliaSearchClient.SearchResponse
  
  
  /// Initializes a new `AlgoliaSearchResponse` object with the provided Algolia search response object.
  ///
  /// - Parameter searchResponse: The Algolia search response object.
  public init(searchResponse: AlgoliaSearchClient.SearchResponse) {
    self.searchResponse = searchResponse
  }
  
  /// Fetches the hits from the Algolia search response and decodes them into an array of `Decodable` objects.
  ///
  /// - Returns: An array of `Decodable` objects representing the search results.
  /// - Throws: An error if the decoding process fails.
  func fetchHits<T: Decodable>() throws -> [T] {
    let hitsData = try JSONEncoder().encode(searchResponse.hits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }
    
  /// Fetches a page of search results from the Algolia search response.
  ///
  /// - Returns: An `AlgoliaHitsPage` object containing the search results and pagination information.
  public func fetchPage() -> AlgoliaHitsPage<Hit> {
    AlgoliaHitsPage(page: searchResponse.page!,
                    hits: try! fetchHits(),
                    hasPrevious: searchResponse.page! > 0,
                    hasNext: searchResponse.page! < searchResponse.nbPages!-1)
  }
}
