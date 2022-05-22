//
//  CurrentFiltersDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 08.04.2022.
//

import Foundation
import InstantSearchCore

class CurrentFiltersDemoController {

  let filterState: FilterState
  let clearFiltersConnector: FilterClearConnector
  let currentFiltersListConnector: CurrentFiltersConnector

  init() {
    filterState = .init()
    currentFiltersListConnector = .init(filterState: filterState)
    clearFiltersConnector = .init(filterState: filterState)
    setup()
  }

  func setup() {

    let filterFacet1 = Filter.Facet(attribute: "category", value: "table")
    let filterFacet2 = Filter.Facet(attribute: "category", value: "chair")
    let filterFacet3 = Filter.Facet(attribute: "category", value: "clothes")
    let filterFacet4 = Filter.Facet(attribute: "category", value: "kitchen")

    filterState[or: "filterFacets"].add(filterFacet1,
                                        filterFacet2,
                                        filterFacet3,
                                        filterFacet4)

    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)

    filterState[and: "filterNumerics"].add(filterNumeric1,
                                           filterNumeric2)

    filterState.notifyChange()
  }

}
