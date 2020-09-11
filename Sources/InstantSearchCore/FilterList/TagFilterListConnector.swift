//
//  TagFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Filtering component that displays any kind of tag filters and lets the user refine the search results by selecting them.
public typealias TagFilterListConnector = FilterListConnector<Filter.Tag>

public extension TagFilterListConnector {
  
  /**
   - Parameters:
     - tagFilters: List of tag filters to display.
     - selectionMode: Whether the list can have `single` or `multiple` selections.
     - filterState: The filter state  that will hold your filters.
     - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
     - groupName: Filter group name
   */
  convenience init(tagFilters: [InstantSearchCore.Filter.Tag] = [],
                   selectionMode: SelectionMode = .multiple,
                   filterState: FilterState,
                   `operator`: RefinementOperator,
                   groupName: String) {
    let interactor = TagFilterListInteractor(items: tagFilters,
                                             selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
  /**
   - Parameters:
     - numericFilters: List of tag filters to display.
     - selectionMode: Whether the list can have `single` or `multiple` selections.
     - filterState: The filter state  that will hold your filters.
     - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state.
     - groupName: Filter group name
     - controller: Controller interfacing with a filter list view
   */
  convenience init<Controller: SelectableListController>(tagFilters: [InstantSearchCore.Filter.Tag] = [],
                                                         selectionMode: SelectionMode = .multiple,
                                                         filterState: FilterState,
                                                         `operator`: RefinementOperator,
                                                         groupName: String,
                                                         controller: Controller) where Controller.Item == InstantSearchCore.Filter.Tag {
    let interactor = TagFilterListInteractor(items: tagFilters,
                                             selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName,
              controller: controller)
  }
  
}
