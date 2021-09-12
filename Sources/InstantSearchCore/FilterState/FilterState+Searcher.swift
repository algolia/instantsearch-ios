//
//  FilterState+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public extension FilterState {

  struct SearcherConnection<S: AnyObject & Searchable & FiltersSettable>: Connection {

    public let filterState: FilterState
    public let searcher: S

    public func connect() {
      filterState.onChange.subscribePast(with: searcher) { searcher, filterState in
        let filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.setFilters(filters)
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: searcher)
    }

  }

  @discardableResult func connectSearcher<S: FiltersSettable>(_ searcher: S) -> SearcherConnection<S> {
    let connection = SearcherConnection(filterState: self, searcher: searcher)
    connection.connect()
    return connection
  }

}
