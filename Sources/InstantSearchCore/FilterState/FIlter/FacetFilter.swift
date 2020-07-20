//
//  Facet.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/** Defines facet filter
 # See also:
 [Filter by string](https:www.algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-string/)
 [Filter by boolean](https:www.algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-boolean/)
 */

public extension Filter {

  struct Facet: FilterType, Equatable {

    public let attribute: Attribute
    public let value: ValueType
    public var isNegated: Bool
    public let score: Int?

    public init(attribute: Attribute, value: ValueType, isNegated: Bool = false, score: Int? = nil) {
      self.attribute = attribute
      self.isNegated = isNegated
      self.value = value
      self.score = score
    }

    public init(attribute: Attribute, stringValue: String, isNegated: Bool = false) {
      self.init(attribute: attribute, value: .string(stringValue), isNegated: isNegated)
    }

    public init(attribute: Attribute, floatValue: Float, isNegated: Bool = false) {
      self.init(attribute: attribute, value: .float(floatValue), isNegated: isNegated)
    }

    public init(attribute: Attribute, boolValue: Bool, isNegated: Bool = false) {
      self.init(attribute: attribute, value: .bool(boolValue), isNegated: isNegated)
    }

  }

}

extension Filter.Facet: Hashable {}

extension Filter.Facet: RawRepresentable {

  public typealias RawValue = (Attribute, ValueType)

  public init?(rawValue: (Attribute, Filter.Facet.ValueType)) {
    self.init(attribute: rawValue.0, value: rawValue.1)
  }

  public var rawValue: (Attribute, Filter.Facet.ValueType) {
    return (attribute, value)
  }

}

extension Filter.Facet: CustomStringConvertible {

  public var description: String {
    return "\(attribute): \(value.description)"
  }

}

extension Filter.Facet {

  public enum ValueType: CustomStringConvertible, Hashable {

    case string(String)
    case float(Float)
    case bool(Bool)

    public var description: String {
      switch self {
      case .string(let value):
        return value
      case .bool(let value):
        return "\(value)"
      case .float(let value):
        return "\(value)"
      }
    }

  }

}

extension Filter.Facet.ValueType: ExpressibleByBooleanLiteral {

  public typealias BooleanLiteralType = Bool

  public init(booleanLiteral value: BooleanLiteralType) {
    self = .bool(value)
  }

}

extension Filter.Facet.ValueType: ExpressibleByFloatLiteral {

  public typealias FloatLiteralType = Float

  public init(floatLiteral value: FloatLiteralType) {
    self = .float(value)
  }

}

extension Filter.Facet.ValueType: ExpressibleByStringLiteral {

  public typealias StringLiterlalType = String

  public init(stringLiteral value: StringLiteralType) {
    self = .string(value)
  }

}

extension Filter.Facet.ValueType: ExpressibleByIntegerLiteral {

  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: IntegerLiteralType) {
    self = .float(Float(value))
  }

}
