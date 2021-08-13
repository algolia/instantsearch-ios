//
//  FilterState+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public protocol FiltersSettable {
  
  func setFilters(_ filters: String?)
  
}

public protocol FacetingSource: AnyObject {
  
  var disjunctiveFacetingDelegate: DisjunctiveFacetingDelegate? { get set }
  var hierarchicalFacetingDelegate: HierarchicalFacetingDelegate? { get set }
  
}

public extension FilterState {
  
  struct SearcherConnection<Searcher: AnyObject & FiltersSettable>: Connection {
    
    public let filterState: FilterState
    public let searcher: Searcher

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
  
  @discardableResult func connectSearcher<Searcher: FiltersSettable>(_ searcher: Searcher) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(filterState: self, searcher: searcher)
    connection.connect()
    return connection
  }

  
}
