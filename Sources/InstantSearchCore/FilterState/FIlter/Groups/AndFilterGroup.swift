//
//  AndFilterGroup.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 14/01/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Representation of conjunctive group of filters

extension FilterGroup {

  public struct And: FilterGroupType {

    public var filters: [FilterType]
    public let name: String?

    public var isDisjuncitve: Bool {
      return false
    }

    public init<S: Sequence>(filters: S, name: String? = nil) where S.Element == FilterType {
      self.filters = Array(filters)
      self.name = name
    }

    public static func and(_ filters: [FilterType]) -> FilterGroup.And {
      return FilterGroup.And(filters: filters)
    }

    public func withFilters<S: Sequence>(_ filters: S) -> FilterGroup.And where S.Element == FilterType {
      return .init(filters: filters, name: name)
    }

  }

}

extension FilterGroup.And: CustomStringConvertible {

  public var description: String {
    return "{ \(name ?? "_"): \(filters) }"
  }

}
