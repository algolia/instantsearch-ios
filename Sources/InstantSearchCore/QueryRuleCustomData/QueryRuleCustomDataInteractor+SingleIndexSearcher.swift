//
//  QueryRuleCustomDataInteractor+SingleIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

extension QueryRuleCustomDataInteractor {

  /// Connection between a rule custom data logic and a single index searcher
  @available(*, deprecated, message: "Use QueryRuleCustomDataInteractor.SearcherConnection")
  public struct SingleIndexSearcherConnection: Connection {

    /// Logic applied to the custom model
    public let interactor: QueryRuleCustomDataInteractor

    /// Searcher that handles your searches
    public let searcher: HitsSearcher

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searcher: Searcher to connect
    */
    public init(interactor: QueryRuleCustomDataInteractor,
                searcher: HitsSearcher) {
      self.searcher = searcher
      self.interactor = interactor
    }

    public func connect() {
      searcher.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
        interactor.extractModel(from: searchResponse)
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
  */
  @discardableResult func connectSearcher<S: Searcher>(_ searcher: S) -> Connection where S: SearchResultObservable, S.SearchResult == SearchResponse {
    let connection = SearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
