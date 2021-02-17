//
//  DynamicSortToggleInteractor+MultiIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

extension DynamicSortToggleInteractor {

  public struct MultiIndexSearcherConnection: Connection {

    public let interactor: DynamicSortToggleInteractor
    public let searcher: MultiIndexSearcher
    public let queryIndex: Int

    public func connect() {
      let queryIndex = self.queryIndex
      interactor.onItemChanged.subscribe(with: searcher) { (searcher, priority) in
        guard let priority = priority else { return }
        searcher.indexQueryStates[queryIndex].query.relevancyStrictness = priority.relevancyStrictness
        searcher.onQueryChanged.fire(searcher.query)
        searcher.search()
      }
      searcher.onResults.subscribePast(with: interactor) { (interactor, searchesResponse) in
        if let receivedRelevancyStrictness = searchesResponse.results[queryIndex].appliedRelevancyStrictness {
          let dynamicSortPriority = DynamicSortPriority(relevancyStrictness: receivedRelevancyStrictness)
          if dynamicSortPriority != interactor.item {
            interactor.item = dynamicSortPriority
          }
        } else {
          interactor.item = .none
        }
      }
    }

    public func disconnect() {
      interactor.onItemChanged.cancelSubscription(for: searcher)
      searcher.onResults.cancelSubscription(for: interactor)
    }

  }

  @discardableResult public func connectSearcher(_ searcher: MultiIndexSearcher,
                                                 queryIndex: Int) -> MultiIndexSearcherConnection {
    let connection = MultiIndexSearcherConnection(interactor: self, searcher: searcher, queryIndex: queryIndex)
    connection.connect()
    return connection
  }

}
