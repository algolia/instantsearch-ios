//
//  Query+Facets.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension Query {

  mutating func updateQueryFacets(with attribute: Attribute) {
    facets = (facets ?? []).union([attribute])
  }

}
