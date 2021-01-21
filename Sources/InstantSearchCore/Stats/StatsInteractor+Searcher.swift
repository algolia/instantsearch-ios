//
//  StatsInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 07/12/2020.
//

import Foundation

public extension StatsInteractor {

  struct SearcherConnection<Searcher: SearchResultObservable>: Connection where Searcher.SearchResult == SearchResponse {

    public let interactor: StatsInteractor
    public let searcher: Searcher

    public init(interactor: StatsInteractor, searcher: Searcher) {
      self.interactor = interactor
      self.searcher = searcher
    }

    public func connect() {
      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in
        interactor.item = searchResults.searchStats
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
