//
//  FilterListInteractor+Numeric.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias NumericFilterListInteractor = FilterListInteractor<Filter.Numeric>

public extension NumericFilterListInteractor {

  convenience init(numericFilters: [Filter.Numeric] = []) {
    self.init(items: numericFilters, selectionMode: .single)
  }

}
