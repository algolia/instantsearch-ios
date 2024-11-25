//
//  FiltersStorage.swift
//  
//
//  Created by Vladislav Fitc on 07/07/2020.
//

import Foundation

public struct FiltersStorage: Equatable {

  public var units: [Unit]

  public init(units: [Unit]) {
    self.units = units
  }

  public enum Unit: Equatable {
    case and([String])
    case or([String])
  }

  public static func and(_ units: Unit...) -> Self {
    .init(units: units)
  }

}

extension FiltersStorage.Unit {

  public static func and(_ filters: String...) -> Self {
    .and(filters)
  }

  public static func or(_ filters: String...) -> Self {
    .or(filters)
  }

}

extension FiltersStorage: RawRepresentable {

  public var rawValue: [SingleOrList<String>] {
    var output: [SingleOrList<String>] = []
    for unit in units {
      switch unit {
      case .and(let values):
        output.append(contentsOf: values.map { SingleOrList.single($0) })
      case .or(let values):
        output.append(.list(values))
      }
    }
    return output
  }

  public init(rawValue: [SingleOrList<String>]) {
    var units: [Unit] = []
    for element in rawValue {
      switch element {
      case .single(let value):
        units.append(.and([value]))
      case .list(let values):
        units.append(.or(values))
      }
    }
    self.init(units: units)
  }

}

extension FiltersStorage: Codable {

  public init(from decoder: Decoder) throws {
    self.init(rawValue: try RawValue(from: decoder))
  }

  public func encode(to encoder: Encoder) throws {
    try rawValue.encode(to: encoder)
  }

}

extension FiltersStorage.Unit: ExpressibleByStringInterpolation {

  public init(stringLiteral value: String) {
    self = .and([value])
  }

}

extension FiltersStorage: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: Unit...) {
    self.init(units: elements)
  }

}
