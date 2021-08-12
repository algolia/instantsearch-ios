//
//  QueryRuleCustomDataInteractor+MultiIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

extension QueryRuleCustomDataInteractor {

  /// Connection between a rule custom data logic and a multi-index searcher
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  public struct MultiIndexSearcherConnection: Connection {

    /// Logic applied to the custom model
    public let interactor: QueryRuleCustomDataInteractor

    /// Searcher that handles your searches
    public let searcher: MultiIndexSearcher

    /// Index of query from response of which the user data will be extracted
    public let queryIndex: Int

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searcher: Searcher to connect
       - queryIndex: Index of query from response of which the user data will be extracted
    */
    public init(interactor: QueryRuleCustomDataInteractor,
                searcher: MultiIndexSearcher,
                queryIndex: Int) {
      self.searcher = searcher
      self.queryIndex = queryIndex
      self.interactor = interactor
    }

    public func connect() {
      searcher.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        interactor.extractModel(from: searchResponse.results[queryIndex])
      }
    }

    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
    }

  }

}

public extension QueryRuleCustomDataInteractor {

  /**
   - Parameters:
     - searcher: Searcher to connect
     - queryIndex: Index of query from response of which the user data will be extracted
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  @discardableResult func connectSearcher(_ searcher: MultiIndexSearcher,
                                          toQueryAtIndex queryIndex: Int) -> MultiIndexSearcherConnection {
    let connection = MultiIndexSearcherConnection(interactor: self, searcher: searcher, queryIndex: queryIndex)
    connection.connect()
    return connection
  }

}
