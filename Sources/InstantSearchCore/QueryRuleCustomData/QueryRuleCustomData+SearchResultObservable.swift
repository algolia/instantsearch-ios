//
//  QueryRuleCustomData+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 27/11/2020.
//

import Foundation

extension QueryRuleCustomDataInteractor {

  /// Connection between a rule custom data logic and a single index searcher
  public struct SearchResultConnection<S: SearchResultObservable>: Connection where S.SearchResult == SearchResponse {

    /// Logic applied to the custom model
    public let interactor: QueryRuleCustomDataInteractor

    /// Searcher that handles your searches
    public let searchResultObservable: S

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searchResultObservable: SearchResultObservable implementation to connect
    */
    public init(interactor: QueryRuleCustomDataInteractor, searchResultObservable: S) {
      self.searchResultObservable = searchResultObservable
      self.interactor = interactor
    }

    public func connect() {
      searchResultObservable.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        interactor.extractModel(from: searchResponse)
      }
    }

    public func disconnect() {
      searchResultObservable.onResults.cancelSubscription(for: interactor)
    }

  }

}
