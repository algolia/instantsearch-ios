//
//  SortByConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

public class SortByConnector: Connection {

  public let searcher: SingleIndexSearcher
  public let interactor: IndexSegmentInteractor

  public let searcherConnection: Connection

  init(searcher: SingleIndexSearcher,
       indices: [Int: Index],
       selected: Int? = nil) {
    self.searcher = searcher
    self.interactor = .init(items: indices)
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
    self.interactor.selected = selected
  }

  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }

}
