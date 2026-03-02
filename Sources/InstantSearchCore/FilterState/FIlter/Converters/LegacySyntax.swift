//
//  LegacySyntax.swift
//  AlgoliaSearch
//
//  Created by Vladislav Fitc on 05/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol LegacySyntaxConvertible {
  var legacyForm: FiltersStorage { get }
}

public extension FilterConverter {
  func legacy(_ filter: FilterType) -> FiltersStorage? {
    return (filter as? LegacySyntaxConvertible)?.legacyForm
  }
}

public extension FilterGroupConverter {
  func legacy(_ group: FilterGroupType) -> FiltersStorage? {
    return (group as? LegacySyntaxConvertible)?.legacyForm
  }

  func legacy<C: Sequence>(_ groups: C) -> FiltersStorage? where C.Element == FilterGroupType {
    let units = groups
      .filter { !$0.filters.isEmpty }
      .compactMap { $0 as? LegacySyntaxConvertible }
      .map(\.legacyForm)
      .flatMap(\.units)
    return FiltersStorage(units: units)
  }
}

extension Filter.Numeric: LegacySyntaxConvertible {
  public var legacyForm: FiltersStorage {
    switch value {
    case let .comparison(`operator`, value):
      let `operator` = isNegated ? `operator`.inversion : `operator`
      let expression = """
      \(attribute) \(`operator`.rawValue) \(value)
      """
      return FiltersStorage(units: [.and([expression])])

    case let .range(range):
      let units = [
        Filter.Numeric(attribute: attribute, operator: isNegated ? .lessThan : .greaterThanOrEqual, value: range.lowerBound),
        Filter.Numeric(attribute: attribute, operator: isNegated ? .greaterThan : .lessThanOrEqual, value: range.upperBound)
      ]
      .compactMap { $0.legacyForm }
      .flatMap(\.units)
      return FiltersStorage(units: units)
    }
  }
}

extension Filter.Facet: LegacySyntaxConvertible {
  public var legacyForm: FiltersStorage {
    let scoreExpression = score.flatMap { "<score=\(String($0))>" } ?? ""
    let valuePrefix = isNegated ? "-" : ""
    let expression = """
    \(attribute):\(valuePrefix)\(value.legacyStringValue)\(scoreExpression)
    """
    return FiltersStorage(units: [.and([expression])])
  }
}

extension Filter.Tag: LegacySyntaxConvertible {
  public var legacyForm: FiltersStorage {
    let valuePrefix = isNegated ? "-" : ""
    let expression = """
    \(attribute):\(valuePrefix)\(value)
    """
    return FiltersStorage(units: [.and([expression])])
  }
}

extension FilterGroup.And: LegacySyntaxConvertible {
  var legacyForm: FiltersStorage {
    let rawFilters = filters
      .compactMap { $0 as? LegacySyntaxConvertible }
      .map(\.legacyForm)
      .flatMap(\.units)
      .flatMap(\.rawFilters)
    return FiltersStorage(units: [.and(rawFilters)])
  }
}

extension FilterGroup.Or: LegacySyntaxConvertible {
  var legacyForm: FiltersStorage {
    let rawFilters = filters
      .compactMap { $0 as? LegacySyntaxConvertible }
      .map(\.legacyForm)
      .flatMap(\.units)
      .flatMap(\.rawFilters)
    return FiltersStorage(units: [.or(rawFilters)])
  }
}

internal extension FiltersStorage.Unit {
  var rawFilters: [String] {
    switch self {
    case let .and(values),
         let .or(values):
      return values
    }
  }
}

private extension Filter.Facet.ValueType {
  var legacyStringValue: String {
    switch self {
    case let .string(value):
      let needsQuoting = value.contains(" ") || value.contains(":")
      let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
      return needsQuoting ? "\"\(escaped)\"" : escaped
    case let .number(value):
      return String(value)
    case let .bool(value):
      return value ? "true" : "false"
    }
  }
}
