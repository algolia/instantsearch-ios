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
   Connection between FacetSearcher and FilterState
   */
  struct FilterStateConnection: Connection {

    /// 
    public let facetSearcher: FacetSearcher

    /// Connected FilterState
    public let filterState: FilterState

    /// Whether search for facet must be launched on FilterState change
    public let triggerSearchOnFilterStateChange: Bool

    public init(facetSearcher: FacetSearcher, filterState: FilterState, triggerSearchOnFilterStateChange: Bool) {
      self.facetSearcher = facetSearcher
      self.filterState = filterState
      self.triggerSearchOnFilterStateChange = triggerSearchOnFilterStateChange
    }

    public func connect() {
      let shouldTriggerSearch = triggerSearchOnFilterStateChange
      filterState.onChange.subscribePast(with: facetSearcher) { searcher, filterState in
        searcher.request.context.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
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

  /**
   Establishes connection between facet searcher and FilterState
   - Updates filters parameter of Searcher's `Query` according to a new `FilterState` content and relaunches search once `FilterState` changed
   - Parameter filterState: filter state to connect
   - Parameter triggerSearchOnFilterStateChange: whether search for facet must be launched on FilterState change
   */
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             triggerSearchOnFilterStateChange: Bool = true) -> FilterStateConnection {
    let connection = FilterStateConnection(facetSearcher: self, filterState: filterState, triggerSearchOnFilterStateChange: triggerSearchOnFilterStateChange)
    connection.connect()
    return connection
  }

}
