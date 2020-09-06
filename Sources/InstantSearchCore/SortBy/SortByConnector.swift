//
//  SortByConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// Component that displays a list of indices, allowing a user to change the way hits are sorted
public class SortByConnector {
  
  /// Searcher that handles your searches
  public let searcher: SingleIndexSearcher
  
  /// Logic applied to the indices
  public let interactor: IndexSegmentInteractor
  
  /// Connection between interactor and searcher
  public let searcherConnection: Connection
  
  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Logic applied to the indices
   */
  public init(searcher: SingleIndexSearcher,
              interactor: IndexSegmentInteractor) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher: searcher)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of the indices names to switch between
     - selected: Consecutive index of the initially selected search index in the list.
   */
  public convenience init(searcher: SingleIndexSearcher,
                          indicesNames: [IndexName],
                          selected: Int? = nil) {
    let enumeratedIndices = indicesNames
      .map(searcher.client.index(withName:))
      .enumerated()
      .map { $0 }
    let items = [Int: Index](uniqueKeysWithValues: enumeratedIndices)
    let interactor = IndexSegmentInteractor(items: items)
    interactor.selected = selected
    self.init(searcher: searcher, interactor: interactor)
  }

}

extension SortByConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }
  
}
