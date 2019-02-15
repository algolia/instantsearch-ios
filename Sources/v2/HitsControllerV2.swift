//
//  HitsControllerV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation

protocol HitsWidgetV2 {
  func reloadHits()
}

class HitsControllerV2 {

  let hitsViewModel: HitsViewModelV2
  // weak hitsWidgets

  public init(index: Index, query: Query, hitsWidget: [HitsWidgetV2]) {
    hitsViewModel = HitsViewModelV2 { page, resultHandler in
      // Do the search and then when we get the results:
      // {
      query.page = page
      // use searchCoordinator + index + new query to search

      resultHandler(SearchResults(nbHits: 0, hits: [[:]]), nil, [:])
      hitsWidget.forEach { $0.reloadHits() }
      // Or instead of a handler, we can just call a setter method on the viewModel...
      // }
    }
  }
}
