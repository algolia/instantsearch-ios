//
//  DynamicSortToggleInteractor+SingleIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

extension DynamicSortToggleInteractor {
  
  public struct SingleIndexSearcherConnection: Connection {

    public let interactor: DynamicSortToggleInteractor
    public let searcher: SingleIndexSearcher
    
    public func connect() {
      interactor.onItemChanged.subscribe(with: searcher) { (searcher, priority) in
        guard let priority = priority else { return }
        searcher.indexQueryState.query.relevancyStrictness = priority.relevancyStrictness
        searcher.onQueryChanged.fire(searcher.query)
        searcher.search()
      }
      searcher.onResults.subscribePast(with: interactor) { (interactor, searchResponse) in
        if let receivedRelevancyStrictness = searchResponse.appliedRelevancyStrictness {
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
  
  @discardableResult public func connectSearcher(_ searcher: SingleIndexSearcher) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }
  
}
