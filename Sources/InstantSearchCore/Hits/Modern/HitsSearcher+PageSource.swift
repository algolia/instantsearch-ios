//
//  HitsSearcher+PageSource.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class HitsSearcherPageSource<Hit: Decodable>: PageSource {
  
  public typealias ItemsPage = AlgoliaHitsPage<Hit>
  
  public typealias Item = Hit
  
  let hitsSearcher: HitsSearcher
  
  public init(hitsSearcher: HitsSearcher) {
    self.hitsSearcher = hitsSearcher
    hitsSearcher.onQueryChanged.subscribe(with: self) { _, _ in
      
    }
  }
  
  public func fetchInitialPage() async throws -> ItemsPage {
    hitsSearcher.request.query.page = 0
    return try await getPage()
  }
  
  public func fetchPage(before page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page-1
    return try await getPage()
  }
  
  public func fetchPage(after page: ItemsPage) async throws -> ItemsPage {
    hitsSearcher.request.query.page = page.page+1
    return try await getPage()
  }
   
  private func getPage() async throws -> ItemsPage {
    try await withCheckedThrowingContinuation { continuation in
      hitsSearcher.onResults.subscribeOnce(with: self) { searcher, response in
        let page = AlgoliaSearchResponse<Hit>(searchResponse: response).fetchPage()
        continuation.resume(returning: page)
      }
      hitsSearcher.onError.subscribeOnce(with: self) { searcher, error in
        continuation.resume(throwing: error)
      }
      hitsSearcher.search()
    }
  }

  
}

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
