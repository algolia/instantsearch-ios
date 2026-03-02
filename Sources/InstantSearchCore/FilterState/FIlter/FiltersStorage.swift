//
//  FiltersStorage.swift
//  InstantSearchCore
//

import Foundation

/// Legacy-style storage for grouped filters (AND/OR lists).
public struct FiltersStorage: Hashable {
  public enum Unit: Hashable {
    case and([String])
    case or([String])
  }

  public let units: [Unit]

  public init(units: [Unit]) {
    self.units = units
  }

  public static func and(_ unit: Unit) -> FiltersStorage {
    return .init(units: [unit])
  }

  public static func or(_ unit: Unit) -> FiltersStorage {
    return .init(units: [unit])
  }

  public static func and(_ values: [String]) -> FiltersStorage {
    return .init(units: [.and(values)])
  }

  public static func or(_ values: [String]) -> FiltersStorage {
    return .init(units: [.or(values)])
  }
}
