//
//  FacetListDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class FacetListDemoController {

  let searcher: HitsSearcher
  let filterState: FilterState

  let clearConnector: FilterClearConnector
  let colorConnector: FacetListConnector
  let categoryConnector: FacetListConnector
  let promotionConnector: FacetListConnector

  init<CC: FacetListController, PC: FacetListController, CTC: FacetListController>(colorController: CC,
                                                                                   promotionController: PC,
                                                                                   categoryController: CTC) {
    searcher = .init(client: .instantSearch,
                     indexName: .facetList)
    filterState = .init()
    clearConnector = .init(filterState: filterState)

    // Color
    let colorPresenter = FacetListPresenter(sortBy: [.isRefined, .alphabetical(order: .ascending)], limit: 3)

    colorConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "color",
                           selectionMode: .single,
                           facets: [],
                           operator: .and,
                           controller: colorController,
                           presenter: colorPresenter)

    // Promotion
    let promotionPresenter = FacetListPresenter(sortBy: [.count(order: .descending)], limit: 5)

    promotionConnector = .init(searcher: searcher,
                               filterState: filterState,
                               attribute: "promotions",
                               selectionMode: .multiple,
                               facets: [],
                               operator: .and,
                               controller: promotionController,
                               presenter: promotionPresenter)

    // Category
    let categoryRefinementListPresenter = FacetListPresenter(sortBy: [.count(order: .descending), .alphabetical(order: .ascending)], showEmptyFacets: false)

    categoryConnector = .init(searcher: searcher,
                              filterState: filterState,
                              attribute: "category",
                              selectionMode: .multiple,
                              facets: [],
                              operator: .or,
                              controller: categoryController,
                              presenter: categoryRefinementListPresenter)

    // Predefined filter
    let greenColor = Filter.Facet(attribute: "color", stringValue: "green")
    let groupID = FilterGroup.ID.and(name: "color")
    filterState.notify(.add(filter: greenColor, toGroupWithID: groupID))

    searcher.connectFilterState(filterState)
    searcher.search()
  }

}
