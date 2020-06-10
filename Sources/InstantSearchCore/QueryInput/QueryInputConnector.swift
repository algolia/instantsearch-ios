//
//  QueryInputConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class QueryInputConnector<S: Searcher>: Connection {

  public let searcher: S
  public let interactor: QueryInputInteractor
  public let searchTriggeringMode: SearchTriggeringMode

  public let searcherConnection: Connection

  public init(searcher: S,
              interactor: QueryInputInteractor = .init(),
              searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    self.searcher = searcher
    self.interactor = interactor
    self.searchTriggeringMode = searchTriggeringMode
    self.searcherConnection = interactor.connectSearcher(searcher)
  }

  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }

}
