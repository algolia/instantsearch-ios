//
//  HitsSearcher+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension HitsSearcher {

  /**
   Establishes connection between searcher and filterState
   - Sets `FilterState` as a disjunctive and hierarchical faceting delegate
   - Updates filters parameter of Searcher's `Query` according to a new `FilterState` content and relaunches search once `FilterState` changed
   - Parameter filterState: filter state to connect
   */

  struct FilterStateConnection: Connection {
    
    @available(*, deprecated, renamed: "hitsSearcher")
    public var singleIndexSearcher: HitsSearcher {
      return hitsSearcher
    }

    public let hitsSearcher: HitsSearcher
    public let filterState: FilterState

    public func connect() {
      hitsSearcher.disjunctiveFacetingDelegate = filterState
      hitsSearcher.hierarchicalFacetingDelegate = filterState

      filterState.onChange.subscribePast(with: hitsSearcher) { searcher, filterState in
        searcher.request.query.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.request.query.page = 0
        searcher.search()
      }
    }

    public func disconnect() {
      hitsSearcher.disjunctiveFacetingDelegate = nil
      hitsSearcher.hierarchicalFacetingDelegate = nil
      filterState.onChange.cancelSubscription(for: hitsSearcher)
    }

  }

}

public extension HitsSearcher {

  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(hitsSearcher: self, filterState: filterState)
    connection.connect()
    return connection
  }

}
