//
//  FilterState+DisjunctiveFaceting.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension FilterState: DisjunctiveFacetingDelegate {
  public var disjunctiveFacetsAttributes: Set<String> {
    return filters.disjunctiveFacetsAttributes
  }
}
