//
//  MultiIndexSearcher+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexSearcher {

  /**
   Establishes connection between searcher and filterState
   - Updates filters parameter of Searcher's `Query` at specified index according to a new `FilterState` content and relaunches search once `FilterState` changed
   - Parameter filterState: filter state to connect
   - Parameter index: index of query to attach to filter state
   */

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct FilterStateConnection: Connection {

    public let multiIndexSearcher: MultiIndexSearcher
    public let filterState: FilterState
    public let queryIndex: Int

    public func connect() {
      let queryIndex = self.queryIndex
      filterState.onChange.subscribe(with: multiIndexSearcher) { searcher, filterState in
        searcher.indexQueryStates[self.queryIndex].query.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.indexQueryStates[queryIndex].query.page = 0
        searcher.search()
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: multiIndexSearcher)
    }

  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexSearcher {

  @discardableResult func connectFilterState(_ filterState: FilterState, withQueryAtIndex index: Int) -> FilterStateConnection {
    let connection = FilterStateConnection(multiIndexSearcher: self, filterState: filterState, queryIndex: index)
    connection.connect()
    return connection
  }

}
