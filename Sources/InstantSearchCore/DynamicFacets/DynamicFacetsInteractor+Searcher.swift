//
//  DynamicFacetsInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetsInteractor {
  
  struct SearcherConnection<Searcher: SearchResultObservable>: Connection where Searcher.SearchResult == SearchResponse {
    
    /// Business logic
    public let interactor: DynamicFacetsInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searcher: SearchResultObservable implementation to connect
    */
    public init(interactor: DynamicFacetsInteractor, searcher: Searcher) {
      self.searcher = searcher
      self.interactor = interactor
    }
    
    public func connect() {
      searcher.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        if let facetMerchandising = searchResponse.rules?.consequence?.renderingContent?.facetMerchandising {
          interactor.facetOrder = facetMerchandising
        } else {
          interactor.facetOrder = .init()
        }
      }
      (searcher as? ErrorObservable)?.onError.subscribe(with: interactor) { interactor, _ in
        interactor.facetOrder = .init()
      }
    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      (searcher as? ErrorObservable)?.onError.cancelSubscription(for: interactor)
    }

  }
  
  @discardableResult func connectSearcher<Searcher: SearchResultObservable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }
  
}
