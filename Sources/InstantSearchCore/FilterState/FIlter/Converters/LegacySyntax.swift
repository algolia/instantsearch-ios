//
//  LegacySyntax.swift
//  AlgoliaSearch
//
//  Created by Vladislav Fitc on 05/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol LegacySyntaxConvertible {
  var legacyForm: [[String]] { get }
}

extension FilterConverter {

  public func legacy(_ filter: FilterType) -> [[String]]? {
    return (filter as? LegacySyntaxConvertible)?.legacyForm
  }

}

extension FilterGroupConverter {

  public func legacy(_ group: FilterGroupType) -> [[String]]? {
    return (group as? LegacySyntaxConvertible)?.legacyForm
  }

  public func legacy<C: Sequence>(_ groups: C) -> [[String]]? where C.Element == FilterGroupType {
    return groups
      .filter { !$0.filters.isEmpty }
      .compactMap { $0 as? LegacySyntaxConvertible }
      .flatMap { $0.legacyForm }
  }

}

extension Filter.Numeric: LegacySyntaxConvertible {

  public var legacyForm: [[String]] {

    switch value {
    case .comparison(let `operator`, let value):
      let `operator` = isNegated ? `operator`.inversion : `operator`
      let expression = """
      \(attribute) \(`operator`.rawValue) \(value)
      """
      return [[expression]]

    case .range(let range):
      return [
        Filter.Numeric(attribute: attribute, operator: isNegated ? .lessThan : .greaterThanOrEqual, value: range.lowerBound),
        Filter.Numeric(attribute: attribute, operator: isNegated ? .greaterThan : .lessThanOrEqual, value: range.upperBound)
      ].flatMap { $0.legacyForm }
    }

  }

}

extension Filter.Facet: LegacySyntaxConvertible {

  public var legacyForm: [[String]] {
    let scoreExpression = score.flatMap { "<score=\(String($0))>" } ?? ""
    let valuePrefix = isNegated ? "-" : ""
    let expression = """
    \(attribute):\(valuePrefix)\(value)\(scoreExpression)
    """
    return [[expression]]
  }

}

extension Filter.Tag: LegacySyntaxConvertible {

  public var legacyForm: [[String]] {
    let valuePrefix = isNegated ? "-" : ""
    let expression = """
    \(attribute):\(valuePrefix)\(value)
    """
    return [[expression]]
  }

}

extension FilterGroup.And: LegacySyntaxConvertible {

  var legacyForm: [[String]] {
    return filters.compactMap { $0 as? LegacySyntaxConvertible }.flatMap { $0.legacyForm }
  }

}

extension FilterGroup.Or: LegacySyntaxConvertible {

  var legacyForm: [[String]] {
    return [filters.compactMap { $0 as? LegacySyntaxConvertible }.flatMap { $0.legacyForm }.compactMap { $0.first }]
  }

}
