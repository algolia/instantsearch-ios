//
//  HierarchicalConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class HierarchicalConnector: Connection {

  public let searcher: SingleIndexSearcher
  public let filterState: FilterState
  public let interactor: HierarchicalInteractor

  public let searcherConnection: Connection
  public let filterStateConnection: Connection

  public init(searcher: SingleIndexSearcher,
              attribute: Attribute,
              filterState: FilterState,
              hierarchicalAttributes: [Attribute],
              separator: String) {
    self.searcher = searcher
    self.filterState = filterState
    self.interactor = HierarchicalInteractor(hierarchicalAttributes: hierarchicalAttributes, separator: separator)
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
    self.filterStateConnection = interactor.connectFilterState(filterState)
  }

  public func connect() {
    searcherConnection.connect()
    filterStateConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
    filterStateConnection.disconnect()
  }

}
