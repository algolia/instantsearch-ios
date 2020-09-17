//
//  NumericFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Filtering component that displays any kind of numeric filters and lets the user refine the search results by selecting them.
public typealias NumericFilterListConnector = FilterListConnector<Filter.Numeric>

public extension NumericFilterListConnector {

  /**
  - Parameters:
    - numericFilters: List of numeric filters to display.
    - selectionMode: Whether the list can have `single` or `multiple` selections.
    - filterState: Filter state holding your filters
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
    - groupName: Filter group name
  */
  convenience init(numericFilters: [InstantSearchCore.Filter.Numeric] = [],
                   selectionMode: SelectionMode = .single,
                   filterState: FilterState,
                   `operator`: RefinementOperator,
                   groupName: String) {
    let interactor = NumericFilterListInteractor(items: numericFilters,
                                                 selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
  /**
  - Parameters:
    - numericFilters: List of numeric filters to display.
    - selectionMode: Whether the list can have `single` or `multiple` selections.
    - filterState: Filter state holding your filters
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete filter list view
  */
  convenience init<Controller: SelectableListController>(numericFilters: [InstantSearchCore.Filter.Numeric] = [],
                                                         selectionMode: SelectionMode = .single,
                                                         filterState: FilterState,
                                                         `operator`: RefinementOperator,
                                                         groupName: String,
                                                         controller: Controller) where Controller.Item == InstantSearchCore.Filter.Numeric {
    let interactor = NumericFilterListInteractor(items: numericFilters,
                                               selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName,
              controller: controller)
  }

}
