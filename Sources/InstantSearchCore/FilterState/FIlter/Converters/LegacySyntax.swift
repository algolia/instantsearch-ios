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

extension FilterConverter {

  public func legacy(_ filter: FilterType) -> FiltersStorage? {
    return (filter as? LegacySyntaxConvertible)?.legacyForm
  }

}

extension FilterGroupConverter {

  public func legacy(_ group: FilterGroupType) -> FiltersStorage? {
    return (group as? LegacySyntaxConvertible)?.legacyForm
  }

  public func legacy<C: Sequence>(_ groups: C) -> FiltersStorage? where C.Element == FilterGroupType {
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
    case .comparison(let `operator`, let value):
      let `operator` = isNegated ? `operator`.inversion : `operator`
      let expression = """
      \(attribute) \(`operator`.rawValue) \(value)
      """
      return .and(.and(expression))

    case .range(let range):
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
    \(attribute):\(valuePrefix)\(value)\(scoreExpression)
    """
    return .and(.and(expression))
  }

}

extension Filter.Tag: LegacySyntaxConvertible {

  public var legacyForm: FiltersStorage {
    let valuePrefix = isNegated ? "-" : ""
    let expression = """
    \(attribute):\(valuePrefix)\(value)
    """
    return .and(.and(expression))
  }

}

extension FilterGroup.And: LegacySyntaxConvertible {

  var legacyForm: FiltersStorage {
    let rawFilters = filters
      .compactMap { $0 as? LegacySyntaxConvertible }
      .map(\.legacyForm)
      .flatMap(\.units)
      .flatMap(\.rawFilters)
    return .and(.and(rawFilters))
  }

}

extension FilterGroup.Or: LegacySyntaxConvertible {

  var legacyForm: FiltersStorage {
    let rawFilters = filters
      .compactMap { $0 as? LegacySyntaxConvertible }
      .map(\.legacyForm)
      .flatMap(\.units)
      .flatMap(\.rawFilters)
    return .and(.or(rawFilters))
  }

}

internal extension FiltersStorage.Unit {

  var rawFilters: [String] {
    switch self {
    case .and(let values),
         .or(let values):
      return values
    }
  }

}
