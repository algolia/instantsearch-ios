//
//  MultiIndexHitsConnector+Suggestions.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsConnector.IndexModule {

  /**
   Convenient initializer constructing index module for suggestions index
   - Parameters:
     - suggestionsIndexName: Name the search suggestions index
     - hitsInteractor: Logic applied to the suggestions
     - filterState: Filter state holding your suggestions filters
  */
  init(suggestionsIndexName: IndexName,
       hitsInteractor: HitsInteractor<Hit<QuerySuggestion>> = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true),
       filterState: FilterState? = .none) {
    self.init(indexName: suggestionsIndexName,
              hitsInteractor: hitsInteractor,
              filterState: filterState)
  }

}
