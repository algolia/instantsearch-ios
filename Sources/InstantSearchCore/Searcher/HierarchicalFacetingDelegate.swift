//
//  HierarchicalFacetingDelegate.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HierarchicalFacetingDelegate: AnyObject {
  var hierarchicalAttributes: [String] { get set }
  var hierarchicalFilters: [Filter.Facet] { get set }
}
