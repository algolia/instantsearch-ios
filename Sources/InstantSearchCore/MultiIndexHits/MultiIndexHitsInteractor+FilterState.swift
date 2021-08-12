//
//  MultiIndexHitsInteractor+FilterState.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 18/09/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct FilterStateConnection: Connection {

    public let interactor: MultiIndexHitsInteractor
    public let filterState: FilterState

    public func connect() {
      filterState.onChange.subscribePast(with: interactor) { interactor, _ in
        interactor.notifyQueryChanged()
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
    }

  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self, filterState: filterState)
    connection.connect()
    return connection
  }

}
