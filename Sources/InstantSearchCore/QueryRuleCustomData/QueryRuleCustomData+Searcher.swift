//
//  QueryRuleCustomData+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

extension QueryRuleCustomDataInteractor {

  /// Connection between a rule custom data logic and a single index searcher
  public struct SearcherConnection<Searcher: SearchResultObservable>: Connection where Searcher.SearchResult == SearchResponse {

    /// Logic applied to the custom model
    public let interactor: QueryRuleCustomDataInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searcher: SearchResultObservable implementation to connect
    */
    public init(interactor: QueryRuleCustomDataInteractor, searcher: Searcher) {
      self.searcher = searcher
      self.interactor = interactor
    }

    public func connect() {
      searcher.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        interactor.extractModel(from: searchResponse)
      }
      (searcher as? ErrorObservable)?.onError.subscribe(with: interactor) { interactor, _ in
        interactor.item = .none
      }
    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      (searcher as? ErrorObservable)?.onError.cancelSubscription(for: interactor)
    }

  }

}
