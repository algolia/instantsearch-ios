//
//  HierarchicalManageable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 16/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HierarchicalManageable {

  func hierarchicalAttributes(forGroupWithName groupName: String) -> [Attribute]
  func hierarchicalFilters(forGroupWithName groupName: String) -> [Filter.Facet]
  mutating func set(_ hierarchicalAttributes: [Attribute], forGroupWithName groupName: String)
  mutating func set(_ hierarchicalFilters: [Filter.Facet], forGroupWithName groupName: String)

}
