//
//  CompositionSearcher+FilterState.swift
//  InstantSearchCore
//

import Foundation

public extension CompositionSearcher {
  /**
   Establishes connection between searcher and filterState
   - Sets `FilterState` as the disjunctive faceting delegate, so that the refined disjunctive
     attributes are annotated with the `disjunctive` modifier in the requested facets
   - Updates the filters parameter of the searcher's request according to a new `FilterState` content
     and relaunches the search once `FilterState` changed
   - Parameter filterState: filter state to connect
   */
  struct FilterStateConnection: Connection {
    public let compositionSearcher: CompositionSearcher
    public let filterState: FilterState

    public init(compositionSearcher: CompositionSearcher,
                filterState: FilterState) {
      self.compositionSearcher = compositionSearcher
      self.filterState = filterState
    }

    public func connect() {
      compositionSearcher.disjunctiveFacetingDelegate = filterState

      filterState.onChange.subscribePast(with: compositionSearcher) { searcher, filterState in
        searcher.request.params.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.request.params.page = 0
        searcher.search()
      }
    }

    public func disconnect() {
      compositionSearcher.disjunctiveFacetingDelegate = nil
      filterState.onChange.cancelSubscription(for: compositionSearcher)
    }
  }
}

public extension CompositionSearcher {
  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(compositionSearcher: self, filterState: filterState)
    connection.connect()
    return connection
  }
}
