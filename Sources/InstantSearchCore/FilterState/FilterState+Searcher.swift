//
//  FilterState+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public extension FilterState {

  struct SearcherConnection<Searcher: AnyObject & Searchable & FiltersSettable>: Connection {

    /// FilterState that holds search filters
    public let filterState: FilterState

    /// Searcher that handles search requests
    public let searcher: Searcher

    /**
     - Parameters:
       - filterState: FilterState that holds search filters
       - searcher: Searcher that handles search requests
     */
    public init(searcher: Searcher,
                filterState: FilterState) {
      self.searcher = searcher
      self.filterState = filterState
    }

    public func connect() {
      filterState.onChange.subscribePast(with: searcher) { searcher, filterState in
        let filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.setFilters(filters)
        searcher.search()
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: searcher)
    }

  }

  /**
   Connects a searcher
   
   - Parameters:
     - filterState: FilterState that holds search filters
     - searcher: Searcher that handles search requests
   - returns: Established connection
   */
  @discardableResult func connectSearcher<Searcher: AnyObject & Searchable & FiltersSettable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(searcher: searcher, filterState: self)
    connection.connect()
    return connection
  }

}
