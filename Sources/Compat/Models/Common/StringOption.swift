//
//  StringOption.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2020.
//

import Foundation

public protocol StringOption: Codable, Equatable, RawRepresentable where RawValue == String {
}

public extension StringOption {

  init(rawValue: RawValue) {
    self.init(rawValue: rawValue)!
  }

}

public protocol ProvidingCustomOption {

  static func custom(_ value: String) -> Self

}

public extension ProvidingCustomOption where Self: StringOption {

  static func custom(_ value: String) -> Self { .init(rawValue: value) }

}

extension ExpressibleByStringInterpolation where Self: StringOption {

  init(stringLiteral value: String) {
    self = .init(rawValue: value)
  }

}
