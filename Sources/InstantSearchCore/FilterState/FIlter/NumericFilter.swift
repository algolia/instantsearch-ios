//
//  Numeric.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/** Defines filter representing a numeric relation or a range
 # See also:
 [Reference](https:www.algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-numeric-value/)
 */

public extension Filter {

  struct Numeric: FilterType, Equatable {

    public enum ValueType: Hashable {
      case range(ClosedRange<Double>)
      case comparison(Operator, Double)
    }

    public enum Operator: String, CustomStringConvertible {
      case lessThan = "<"
      case lessThanOrEqual = "<="
      case equals = "="
      case notEquals = "!="
      case greaterThanOrEqual = ">="
      case greaterThan = ">"

      var inversion: Operator {
        switch self {
        case .equals:
          return .notEquals
        case .greaterThan:
          return .lessThanOrEqual
        case .greaterThanOrEqual:
          return .lessThan
        case .lessThan:
          return .greaterThanOrEqual
        case .lessThanOrEqual:
          return .greaterThan
        case .notEquals:
          return .equals
        }
      }

      public var description: String {
        return rawValue
      }

    }

    public let attribute: Attribute
    public let value: ValueType
    public var isNegated: Bool

    init(attribute: Attribute, value: ValueType, isNegated: Bool) {
      self.attribute = attribute
      self.isNegated = isNegated
      self.value = value
    }

    public init(attribute: Attribute, range: ClosedRange<Double>, isNegated: Bool = false) {
      self.init(attribute: attribute, value: .range(range), isNegated: isNegated)
    }

    public init(attribute: Attribute, `operator`: Operator, value: Double, isNegated: Bool = false) {
      self.init(attribute: attribute, value: .comparison(`operator`, value), isNegated: isNegated)
    }

  }

}

extension Filter.Numeric.ValueType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .range(let range):
      return "\(range.lowerBound) – \(range.upperBound)"
    case .comparison(let compOperator, let value):
      return "\(compOperator.description) \(value)"
    }
  }

}

extension Filter.Numeric: CustomStringConvertible {

  public var description: String {
    let separator: String
    switch value {
    case .range:
      separator = ":"
    case .comparison:
      separator = ""
    }
    return "\(attribute)\(separator) \(value.description)"
  }

}

extension Filter.Numeric: Hashable {}
