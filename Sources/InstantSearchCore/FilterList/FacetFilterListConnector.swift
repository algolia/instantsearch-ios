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

  /// - Parameter facetFilters: The facet filters to display.
  /// - Parameter selectionMode: Whether the list can have `single` or `multiple` selections.
  /// - Parameter filterState: The filter state  that will hold your filters.
  /// - Parameter operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
  /// - Parameter groupName: Filter group name
  convenience init(facetFilters: [FacetFilter] = [],
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

}
