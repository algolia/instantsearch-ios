//
//  HierarchicalFacetingDelegate.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HierarchicalFacetingDelegate: class {
  var hierarchicalAttributes: [Attribute] { get set }
  var hierarchicalFilters: [Filter.Facet] { get set }
}
