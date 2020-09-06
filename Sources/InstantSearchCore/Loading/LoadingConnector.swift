//
//  LoadingConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that shows a loading indicator during pending requests.
public class LoadingConnector<S: Searcher> {

  /// Searcher that handles your searches
  public let searcher: S
  
  /// Business logic that handles showing a loading indicator
  public let interactor: LoadingInteractor
  
  /// Connection between searcher and interactor
  public let searcherConnection: Connection

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Business logic that handles showing a loading indicator
   */
  public init(searcher: S,
              interactor: LoadingInteractor = .init()) {
    self.searcher = searcher
    self.interactor = interactor
    self.searcherConnection = interactor.connectSearcher(searcher)
  }

}

extension LoadingConnector: Connection {
  
  public func connect() {
    searcherConnection.connect()
  }

  public func disconnect() {
    searcherConnection.disconnect()
  }
  
}
