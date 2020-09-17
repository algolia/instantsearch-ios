//
//  FacetFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Filtering component that displays any kind of facet filters and lets the user refine the search results by selecting them.
public typealias FacetFilterListConnector = FilterListConnector<Filter.Facet>

public extension FacetFilterListConnector {
      
  /**
  - Parameters:
    - facetFilters: List of facet filters to display.
    - selectionMode: Whether the list can have `single` or `multiple` selections.
    - filterState: Filter state holding your filters
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
    - groupName: Filter group name
  */
  convenience init(facetFilters: [InstantSearchCore.Filter.Facet] = [],
                   selectionMode: SelectionMode = .multiple,
                   filterState: FilterState,
                   `operator`: RefinementOperator,
                   groupName: String) {
    let interactor = FacetFilterListInteractor(items: facetFilters,
                                               selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
  /**
  - Parameters:
    - facetFilters: List of facet filters to display.
    - selectionMode: Whether the list can have `single` or `multiple` selections.
    - filterState: Filter state holding your filters
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete filter list view
  */
  convenience init<Controller: SelectableListController>(facetFilters: [InstantSearchCore.Filter.Facet] = [],
                                                         selectionMode: SelectionMode = .multiple,
                                                         filterState: FilterState,
                                                         `operator`: RefinementOperator,
                                                         groupName: String,
                                                         controller: Controller) where Controller.Item == InstantSearchCore.Filter.Facet {
    let interactor = FacetFilterListInteractor(items: facetFilters,
                                               selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName,
              controller: controller)
  }

}
