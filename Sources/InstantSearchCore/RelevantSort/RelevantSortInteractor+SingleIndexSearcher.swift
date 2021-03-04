//
//  RelevantSortInteractor+SingleIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

extension RelevantSortInteractor {

  /// Connection between relevant sort interactor and a searcher handling the search
  public struct SingleIndexSearcherConnection: Connection {

    /// Relevant sort priority toggling logic
    public let interactor: RelevantSortInteractor

    /// Searcher that handles your searches
    public let searcher: SingleIndexSearcher

    /**
     - Parameters:
       - interactor: Relevant sort priority toggling logic
       - searcher: Searcher that handles your searches
     */
    public init(interactor: RelevantSortInteractor,
                searcher: SingleIndexSearcher) {
      self.interactor = interactor
      self.searcher = searcher
    }

    public func connect() {
      interactor.onItemChanged.subscribe(with: searcher) { (searcher, priority) in
        guard let priority = priority else { return }
        searcher.indexQueryState.query.relevancyStrictness = priority.relevancyStrictness
        searcher.onQueryChanged.fire(searcher.query)
        searcher.search()
      }
      searcher.onResults.subscribePast(with: interactor) { (interactor, searchResponse) in
        if let receivedRelevancyStrictness = searchResponse.appliedRelevancyStrictness {
          let relevantSortPriority = RelevantSortPriority(relevancyStrictness: receivedRelevancyStrictness)
          if relevantSortPriority != interactor.item {
            interactor.item = relevantSortPriority
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

  /**
   Establishes a connection with the searcher
   - Parameters:
     - searcher: Searcher that handles your searches
   - Returns: Established connection
   */
  @discardableResult public func connectSearcher(_ searcher: SingleIndexSearcher) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
