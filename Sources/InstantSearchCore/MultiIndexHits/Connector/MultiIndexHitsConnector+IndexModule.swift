//
//  MultiIndexHitsConnector+IndexModule.swift
//  
//
//  Created by Vladislav Fitc on 15/09/2020.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsConnector {

  /// Structure representing a single index search components within a multi-index experience
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct IndexModule {

    /// Name of the index
    public let indexName: IndexName

    /// Logic applied to the hits
    public let hitsInteractor: AnyHitsInteractor

    /// FilterState that holds your filters
    public let filterState: FilterState?

    /**
     - Parameters:
       - indexName: Name of the index
       - hitsInteractor: The logic applied to the hits
       - filterState: FilterState that holds your filters
    */
    public init<Hit: Codable>(indexName: IndexName,
                              hitsInteractor: HitsInteractor<Hit>,
                              filterState: FilterState? = .none) {
      self.indexName = indexName
      self.hitsInteractor = hitsInteractor
      self.filterState = filterState
    }

    /**
     - Parameters:
       - indexName: Name of the index
       - hitsInteractor: Infinite scrolling toggle
       - showItemsOnEmptyQuery: Defines if interactor gives access to  the hits in case of empty query
       - filterState: FilterState that holds your filters
    */
    public init(indexName: IndexName,
                infiniteScrolling: InfiniteScrolling = .on(withOffset: 10),
                showItemsOnEmptyQuery: Bool = true,
                filterState: FilterState? = .none) {
      let hitsInteractor = HitsInteractor<JSON>(infiniteScrolling: infiniteScrolling,
                                                showItemsOnEmptyQuery: showItemsOnEmptyQuery)
      self.init(indexName: indexName,
                hitsInteractor: hitsInteractor,
                filterState: filterState)
    }

  }

}
