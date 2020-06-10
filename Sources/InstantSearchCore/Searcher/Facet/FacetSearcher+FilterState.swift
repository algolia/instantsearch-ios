//
//  FacetSearcher+FilterState.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FacetSearcher {

  /**
   Establishes connection between searcher and filterState
   - Updates filters parameter of Searcher's `Query` according to a new `FilterState` content and relaunches search once `FilterState` changed
   - Parameter filterState: filter state to connect
   */

  struct FilterStateConnection: Connection {

    public let facetSearcher: FacetSearcher
    public let filterState: FilterState
    public let triggerSearchOnFilterStateChange: Bool

    public func connect() {
      let shouldTriggerSearch = triggerSearchOnFilterStateChange
      filterState.onChange.subscribePast(with: facetSearcher) { searcher, filterState in
        searcher.indexQueryState.query.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        if shouldTriggerSearch {
          searcher.search()
        }
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: facetSearcher)
    }

  }

}

public extension FacetSearcher {

  @discardableResult func connectFilterState(_ filterState: FilterState, triggerSearchOnFilterStateChange: Bool = true) -> FilterStateConnection {
    let connection = FilterStateConnection(facetSearcher: self, filterState: filterState, triggerSearchOnFilterStateChange: triggerSearchOnFilterStateChange)
    connection.connect()
    return connection
  }

}
