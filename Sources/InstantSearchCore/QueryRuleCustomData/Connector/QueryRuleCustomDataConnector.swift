//
//  QueryRuleCustomDataConnector.swift
//  
//
//  Created by Vladislav Fitc on 09/10/2020.
//

import Foundation

/// Component that displays custom data from rules.
///
/// [Documentation](https://www.algolia.com/doc/api-reference/widgets/query-rule-custom-data/ios/)
public class QueryRuleCustomDataConnector<Model: Decodable> {

  public typealias Interactor = QueryRuleCustomDataInteractor<Model>

  /// Logic applied to the custom model
  public let interactor: Interactor

  /// Connection between hits interactor and searcher
  public let searcherConnection: Connection

  /// Connections between interactor and controllers
  public var controllerConnections: [Connection]

  internal init(interactor: Interactor,
                connectSearcher: (Interactor) -> Connection) {
    self.interactor = interactor
    searcherConnection = connectSearcher(interactor)
    controllerConnections = []
    searcherConnection.connect()
  }

}

public extension QueryRuleCustomDataConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: External custom data interactor
  */
  convenience init(searcher: HitsSearcher,
                   interactor: Interactor = .init()) {
    self.init(interactor: interactor) {
      QueryRuleCustomDataInteractor<Model>.SearcherConnection(interactor: $0, searcher: searcher)
    }
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - queryIndex: Index of query from response of which the user data will be extracted
     - interactor: External custom data interactor
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init(searcher: MultiIndexSearcher,
                   queryIndex: Int,
                   interactor: Interactor = .init()) {
    self.init(interactor: interactor) {
      QueryRuleCustomDataInteractor<Model>.MultiIndexSearcherConnection(interactor: $0, searcher: searcher, queryIndex: queryIndex)
    }
  }

}

extension QueryRuleCustomDataConnector: Connection {

  public func connect() {
    searcherConnection.connect()
    controllerConnections.forEach { $0.connect() }
  }

  public func disconnect() {
    searcherConnection.disconnect()
    controllerConnections.forEach { $0.disconnect() }
  }

}
