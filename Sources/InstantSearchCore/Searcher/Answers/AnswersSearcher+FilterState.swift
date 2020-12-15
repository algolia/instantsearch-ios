//
//  AnswersSearcher+FilterState.swift
//  
//
//  Created by Vladislav Fitc on 14/12/2020.
//

import Foundation
import AlgoliaSearchClient

public extension AnswersSearcher {

  /**
   Establishes connection between searcher and filterState
   - Sets `FilterState` as a disjunctive and hierarchical faceting delegate
   - Updates filters parameter of Searcher's `Query` according to a new `FilterState` content and relaunches search once `FilterState` changed
   - Parameter filterState: filter state to connect
   */
  struct FilterStateConnection: Connection {

    public let searcher: AnswersSearcher
    public let filterState: FilterState
    
    public init(answersSearcher: AnswersSearcher, filterState: FilterState) {
      self.searcher = answersSearcher
      self.filterState = filterState
    }

    public func connect() {
      filterState.onChange.subscribePast(with: searcher) { searcher, filterState in
        searcher.request.query.filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.search()
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: searcher)
    }
    
  }

}

public extension AnswersSearcher {

  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(answersSearcher: self, filterState: filterState)
    connection.connect()
    return connection
  }

}
