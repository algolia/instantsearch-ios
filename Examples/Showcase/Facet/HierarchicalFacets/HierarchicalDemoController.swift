//
//  HierarchicalDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class HierarchicalDemoController {

  let searcher: HitsSearcher
  let filterState: FilterState
  let clearFilterConnector: FilterClearConnector
  let hierarchicalConnector: HierarchicalConnector

  let hierarchicalAttributes: [Attribute] = [
    "lvl0",
    "lvl1",
    "lvl2",
    "lvl3"
  ].map { "taxon.tree.\($0)" }

  init<Controller: HierarchicalController>(controller: Controller) where Controller.Item == [HierarchicalFacet] {
    searcher = HitsSearcher(appID: "APPID",
                            apiKey: "APIKEY",
                            indexName: "STAGING_product_variants")
    searcher.query = "sunnies"
    filterState = .init()
    clearFilterConnector = .init(filterState: filterState)
    hierarchicalConnector = .init(searcher: searcher,
                                  filterState: filterState,
                                  hierarchicalAttributes: hierarchicalAttributes,
                                  separator: " > ",
                                  controller: controller,
                                  presenter: DefaultPresenter.Hierarchical.present)
    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
