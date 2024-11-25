//
//  JSON.swift
//  InstantSearch
//
//  Created by Dhaya Benmessaoud on 20/11/2024.
//


//
//  JSON.swift
//  
//
//  Created by Vladislav Fitc on 05/03/2020.
//

import Foundation

/// Strongly-typed recursuve JSON representation

public enum JSON: Equatable {
  case string(String)
  case number(Double)
  case dictionary([String: JSON])
  case array([JSON])
  case bool(Bool)
  case null
}

public extension JSON {

  init<T: JSONRepresentable>(_ jsonRepresentable: T) {
    self = jsonRepresentable.json
  }

  init<T: RawRepresentable>(_ rawJsonRepresentable: T) where T.RawValue: JSONRepresentable {
    self = rawJsonRepresentable.rawValue.json
  }

  init<S: Sequence>(jsonSequence: S) where S.Element: JSONRepresentable {
    self = .array(jsonSequence.map(\.json))
  }

  init(_ intValue: Int) {
    self = .number(Double(intValue))
  }

  init(_ floatValue: Float) {
    self = .number(Double(floatValue))
  }

  init(_ doubleValue: Double) {
    self = .number(doubleValue)
  }

  init(_ stringValue: String) {
    self = .string(stringValue)
  }

  init(_ boolValue: Bool) {
    self = .bool(boolValue)
  }

}

extension JSON: ExpressibleByStringInterpolation {

  public init(stringLiteral value: String) {
    self = .string(value)
  }

}

extension JSON: ExpressibleByFloatLiteral {

  public init(floatLiteral value: Double) {
    self = .number(value)
  }

}

extension JSON: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self = .number(Double(value))
  }

}

extension JSON: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self = .bool(value)
  }

}

extension JSON: ExpressibleByDictionaryLiteral {

  public init(dictionaryLiteral elements: (String, JSON)...) {
    self = .dictionary(.init(uniqueKeysWithValues: elements))
  }

}

extension JSON: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: JSON...) {
    self = .array(elements)
  }

}

extension JSON: ExpressibleByNilLiteral {

  public init(nilLiteral: ()) {
    self = .null
  }

}

extension JSON {

  public subscript(_ key: String) -> JSON? {
    guard case .dictionary(let dictionary) = self else { return nil }
    return dictionary[key]
  }

  public subscript(_ index: Int) -> JSON? {
    guard case .array(let array) = self else { return nil }
    return array[index]
  }

}

extension JSON: Codable {

  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .array(array):
      try array.encode(to: encoder)
    case let .dictionary(dictionary):
      try dictionary.encode(to: encoder)
    case let .string(string):
      try string.encode(to: encoder)
    case let .number(number):
      try number.encode(to: encoder)
    case let .bool(bool):
      try bool.encode(to: encoder)
    case .null:
      var container = encoder.singleValueContainer()
      try container.encodeNil()
    }
  }

  public init(from decoder: Decoder) throws {

    let container = try decoder.singleValueContainer()

    if let object = try? container.decode([String: JSON].self) {
      self = .dictionary(object)
    } else if let array = try? container.decode([JSON].self) {
      self = .array(array)
    } else if let string = try? container.decode(String.self) {
      self = .string(string)
    } else if let bool = try? container.decode(Bool.self) {
      self = .bool(bool)
    } else if let number = try? container.decode(Double.self) {
      self = .number(number)
    } else if container.decodeNil() {
      self = .null
    } else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value.")
      )
    }
  }
}

extension JSON: CustomDebugStringConvertible {

  public var debugDescription: String {
    switch self {
    case .string(let str):
      return str.debugDescription
    case .number(let num):
      return num.debugDescription
    case .bool(let bool):
      return bool.description
    case .null:
      return "null"
    default:
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted]
      return (try? encoder.encode(self)).flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
  }
}

extension JSON {

  public init(jsonObject: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
    let decoder = JSONDecoder()
    self = try decoder.decode(JSON.self, from: data)
  }

  public func object() -> Any? {
    switch self {
    case .null:
      return nil
    case .string(let string):
      return string
    case .number(let number):
      return number
    case .bool(let bool):
      return bool
    case .array(let array):
      return array.map { $0.object() }
    case .dictionary(let dictionary):

      var resultDictionary = [String: Any]()
      for (key, value) in dictionary {
        resultDictionary[key] = value.object()
      }
      return resultDictionary
    }
  }

}

extension JSON {

  public init<E: Encodable>(_ encodable: E) throws {
    let data = try JSONEncoder().encode(encodable)
    let jsonDecoder = JSONDecoder()
    self = try jsonDecoder.decode(JSON.self, from: data)
  }

}

extension Dictionary where Key == String, Value == Any {

  public init?(_ json: JSON) {
    guard case let .dictionary(dict) = json else {
      return nil
    }
    var resultDictionary = [String: Any]()
    for (key, value) in dict {
      resultDictionary[key] = value.object()
    }
    self = resultDictionary
  }

}

extension Array where Element == Any {

  public init?(_ json: JSON) {
    guard case let .array(array) = json else {
      return nil
    }
    self = array.compactMap { $0.object() }
  }

}

public protocol JSONRepresentable {

  var json: JSON { get }

}

extension String: JSONRepresentable {

  public var json: JSON { .string(self) }

}

extension Int: JSONRepresentable {}
extension Int8: JSONRepresentable {}
extension Int16: JSONRepresentable {}
extension Int32: JSONRepresentable {}
extension Int64: JSONRepresentable {}
extension UInt: JSONRepresentable {}
extension Double: JSONRepresentable {}
extension Float: JSONRepresentable {}

public extension Numeric where Self: JSONRepresentable, Self: BinaryInteger {

  var json: JSON { .number(Double(self)) }

}

public extension FloatingPoint where Self: JSONRepresentable, Self: BinaryFloatingPoint {

  var json: JSON { .number(Double(self)) }

}

extension Bool: JSONRepresentable {

  public var json: JSON { .bool(self) }

}

extension Sequence where Element: JSONRepresentable {

  public var json: JSON { .init(jsonSequence: self) }

}

extension RawRepresentable where RawValue: JSONRepresentable {

  public var json: JSON { .init(self) }

}
