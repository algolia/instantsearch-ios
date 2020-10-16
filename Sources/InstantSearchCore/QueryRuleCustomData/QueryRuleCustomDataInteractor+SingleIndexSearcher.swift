//
//  QueryRuleCustomDataInteractor+SingleIndexSearcher.swift
//  
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

extension QueryRuleCustomDataInteractor {

  /// Connection between a rule custom data logic and a single index searcher
  public struct SingleIndexSearcherConnection: Connection {

    /// Logic applied to the custom model
    public let interactor: QueryRuleCustomDataInteractor

    /// Searcher that handles your searches
    public let searcher: SingleIndexSearcher

    /**
     - Parameters:
       - interactor: Interactor to connect
       - searcher: Searcher to connect
    */
    public init(interactor: QueryRuleCustomDataInteractor,
                searcher: SingleIndexSearcher) {
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
  @discardableResult func connectSearcher(_ searcher: SingleIndexSearcher) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
