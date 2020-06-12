//
//  OrFilterGroup.swift
//  AlgoliaSearch OSX
//
//  Created by Vladislav Fitc on 14/01/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable type_name

import Foundation

/// Representation of disjunctive group of filters

extension FilterGroup {

  public struct Or<T: FilterType>: FilterGroupType {

    public var filters: [FilterType] {
      return typedFilters
    }

    public let name: String?

    public var isDisjuncitve: Bool {
      return true
    }

    internal var typedFilters: [T]

    public init(filters: [T] = [], name: String? = nil) {
      self.typedFilters = filters
      self.name = name
    }

    public static func or<T: FilterType>(_ filters: [T]) -> FilterGroup.Or<T> {
      return FilterGroup.Or<T>(filters: filters)
    }

    public func withFilters<S: Sequence>(_ filters: S) -> Or where S.Element == FilterType {
      return .init(filters: filters.compactMap { $0 as? T }, name: name)
    }

  }

}

extension FilterGroup.Or: CustomStringConvertible {

  public var description: String {
    return "{ \(name ?? "_"): \(filters) }"
  }

}
