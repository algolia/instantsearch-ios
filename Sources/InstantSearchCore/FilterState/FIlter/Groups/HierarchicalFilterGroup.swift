//
//  HierarchicalFilterGroup.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension FilterGroup {

  public struct Hierarchical: FilterGroupType {

    public var filters: [FilterType] {
      return typedFilters
    }

    public let name: String?

    public var isDisjuncitve: Bool {
      return false
    }

    public var hierarchicalAttributes: [Attribute] = []
    public var hierarchicalFilters: [Filter.Facet] = []

    internal var typedFilters: [Filter.Facet]

    public init<S: Sequence>(filters: S, name: String? = nil) where S.Element == Filter.Facet {
      self.typedFilters = Array(filters)
      self.name = name
    }

    public static func hierarchical(_ filters: [Filter.Facet]) -> FilterGroup.Hierarchical {
      return FilterGroup.Hierarchical(filters: filters)
    }

    public func withFilters<S: Sequence>(_ filters: S) -> FilterGroup.Hierarchical where S.Element == FilterType {
      var updatedGroup = FilterGroup.Hierarchical(filters: filters.compactMap { $0 as? Filter.Facet }, name: name)
      updatedGroup.hierarchicalAttributes = hierarchicalAttributes
      updatedGroup.hierarchicalFilters = hierarchicalFilters
      return updatedGroup
    }

  }

}
