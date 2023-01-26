//
//  AlgoliaController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI

class AlgoliaController {
  let searcher: HitsSearcher

  let searchBoxInteractor: SearchBoxInteractor
  let searchBoxController: SearchBoxObservableController

  let hitsInteractor: HitsInteractor<Item>
  let hitsController: HitsObservableController<Item>

  let statsInteractor: StatsInteractor
  let statsController: StatsTextObservableController

  let filterState: FilterState

  let facetListInteractor: FacetListInteractor
  let facetListController: FacetListObservableController

  init() {
    searcher = HitsSearcher(appID: "latency",
                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                            indexName: "bestbuy")
    searchBoxInteractor = .init()
    searchBoxController = .init()
    hitsInteractor = .init()
    hitsController = .init()
    statsInteractor = .init()
    statsController = .init()
    filterState = .init()
    facetListInteractor = .init()
    facetListController = .init()
    setupConnections()
    searcher.search()
  }

  func setupConnections() {
    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)
    searcher.connectFilterState(filterState)
    facetListInteractor.connectSearcher(searcher, with: "manufacturer")
    facetListInteractor.connectFilterState(filterState, with: "manufacturer", operator: .or)
    facetListInteractor.connectController(facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
  }
}
