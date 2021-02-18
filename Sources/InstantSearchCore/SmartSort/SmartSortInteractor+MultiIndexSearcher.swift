//
//  SmartSortInteractor+MultiIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

extension SmartSortInteractor {

  /// Connection between smart sort interactor and a searcher handling the search
  public struct MultiIndexSearcherConnection: Connection {

    /// Smart sort priority toggling logic
    public let interactor: SmartSortInteractor
    
    /// Searcher that handles your searches
    public let searcher: MultiIndexSearcher
    
    /// Index of query to alter by smart sort toggling
    public let queryIndex: Int
    
    /**
     - Parameters:
       - interactor: Smart sort priority toggling logic
       - searcher: Searcher that handles your searches
       - queryIndex: Index of query to alter by smart sort toggling
     */
    public init(interactor: SmartSortInteractor,
                searcher: MultiIndexSearcher,
                queryIndex: Int) {
      self.interactor = interactor
      self.searcher = searcher
      self.queryIndex = queryIndex
    }

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
          let smartSortPriority = SmartSortPriority(relevancyStrictness: receivedRelevancyStrictness)
          if smartSortPriority != interactor.item {
            interactor.item = smartSortPriority
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
     - queryIndex: Index of query to alter by smart sort toggling
   - Returns: Established connection
   */
  @discardableResult public func connectSearcher(_ searcher: MultiIndexSearcher,
                                                 queryIndex: Int) -> MultiIndexSearcherConnection {
    let connection = MultiIndexSearcherConnection(interactor: self, searcher: searcher, queryIndex: queryIndex)
    connection.connect()
    return connection
  }

}
