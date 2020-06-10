//
//  LoadingConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class LoadingConnector<S: Searcher>: Connection {

  public let searcher: S
  public let interactor: LoadingInteractor
  public let searcherConnection: Connection

  public init(searcher: S,
              interactor: LoadingInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher)
  }

  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }

}
