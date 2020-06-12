//
//  FilterListInteractor+Facet.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FacetFilterListInteractor = FilterListInteractor<Filter.Facet>

public extension FacetFilterListInteractor {

  convenience init(facetFilters: [Filter.Facet] = []) {
    self.init(items: facetFilters, selectionMode: .multiple)
  }

}
