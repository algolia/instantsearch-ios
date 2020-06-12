//
//  NumericFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias NumericFilterListConnector = FilterListConnector<Filter.Numeric>

public extension NumericFilterListConnector {

  convenience init(numericFilters: [NumericFilter] = [],
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

}
