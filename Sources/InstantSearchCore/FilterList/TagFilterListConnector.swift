//
//  TagFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias TagFilterListConnector = FilterListConnector<Filter.Tag>

public extension TagFilterListConnector {

  convenience init(tagFilters: [TagFilter] = [],
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

}
