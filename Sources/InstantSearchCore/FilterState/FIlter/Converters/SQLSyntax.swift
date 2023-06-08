//
//  SQLSyntax.swift
//  AlgoliaSearch
//
//  Created by Vladislav Fitc on 05/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol SQLSyntaxConvertible {
  var sqlForm: String { get }
}

public extension FilterConverter {
  func sql(_ filter: FilterType) -> String? {
    return (filter as? SQLSyntaxConvertible)?.sqlForm
  }
}

public extension FilterGroupConverter {
  func sql(_ group: FilterGroupType) -> String? {
    return (group as? SQLSyntaxConvertible)?.sqlForm
  }

  func sql<C: Collection>(_ groupList: C) -> String? where C.Element == FilterGroupType {
    guard !groupList.isEmpty else { return nil }
    return groupList
      .filter { !$0.filters.isEmpty }
      .compactMap(sql)
      .joined(separator: " AND ")
  }
}

extension Filter.Numeric: SQLSyntaxConvertible {
  public var sqlForm: String {
    let expression: String
    switch value {
    case let .comparison(`operator`, value):
      expression = """
      "\(attribute)" \(`operator`.rawValue) \(value)
      """

    case let .range(range):
      expression = """
      "\(attribute)":\(range.lowerBound) TO \(range.upperBound)
      """
    }
    let prefix = isNegated ? "NOT " : ""
    return prefix + expression
  }
}

extension Filter.Facet: SQLSyntaxConvertible {
  public var sqlForm: String {
    let scoreExpression = score.flatMap { "<score=\(String($0))>" } ?? ""
    let expression = """
    "\(attribute)":"\(value.description.escapingQuotes)\(scoreExpression)"
    """
    let prefix = isNegated ? "NOT " : ""
    return prefix + expression
  }
}

extension Filter.Tag: SQLSyntaxConvertible {
  public var sqlForm: String {
    let expression = """
    "\(attribute)":"\(value.escapingQuotes)"
    """
    let prefix = isNegated ? "NOT " : ""
    return prefix + expression
  }
}

fileprivate extension String {

  var escapingQuotes: String {
    replacingOccurrences(of: "\"", with: "\\\"")
  }

}

extension SQLSyntaxConvertible where Self: FilterGroupType {
  func groupSQLForm(for filters: [FilterType], withSeparator separator: String) -> String {
    let compatibleFilters = filters.compactMap { $0 as? SQLSyntaxConvertible }

    if compatibleFilters.isEmpty {
      return ""
    } else {
      return "( \(compatibleFilters.map { $0.sqlForm }.joined(separator: separator)) )"
    }
  }
}

extension FilterGroup.And: SQLSyntaxConvertible {
  public var sqlForm: String {
    return groupSQLForm(for: filters, withSeparator: " AND ")
  }
}

extension FilterGroup.Or: SQLSyntaxConvertible {
  public var sqlForm: String {
    return groupSQLForm(for: filters, withSeparator: " OR ")
  }
}
