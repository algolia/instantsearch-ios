//
//  StatsConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class StatsConnector: Connection {

  public let searcher: SingleIndexSearcher
  public let interactor: StatsInteractor

  public let searcherConnection: Connection

  public init(searcher: SingleIndexSearcher,
              interactor: StatsInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    searcherConnection = interactor.connectSearcher(searcher)
  }

  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }

}
