//
//  FilterFacet.swift
//  InstantSearchInsights
//

import Foundation

/// Filter facet model stored by Insights events.
public struct FilterFacet: Codable, Hashable {
  public enum Value: Codable, Hashable {
    case string(String)
    case number(Double)
    case bool(Bool)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let boolValue = try? container.decode(Bool.self) {
        self = .bool(boolValue)
      } else if let numberValue = try? container.decode(Double.self) {
        self = .number(numberValue)
      } else {
        self = .string(try container.decode(String.self))
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case let .bool(value):
        try container.encode(value)
      case let .number(value):
        try container.encode(value)
      case let .string(value):
        try container.encode(value)
      }
    }
  }

  public let attribute: String
  public let value: Value
  public var isNegated: Bool
  public let score: Int?

  public init(attribute: String,
              value: Value,
              isNegated: Bool = false,
              score: Int? = nil) {
    self.attribute = attribute
    self.value = value
    self.isNegated = isNegated
    self.score = score
  }
}
