//
//  Distinct.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public struct Distinct: RawRepresentable, Equatable, URLEncodable {

  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }

}

extension Distinct: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: UInt) {
    self.rawValue = value
  }

}

extension Distinct: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self.rawValue = value ? 1 : 0
  }

}

extension Distinct: Codable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let boolValue = try? container.decode(Bool.self) {
      self.init(booleanLiteral: boolValue)
    } else {
      let intValue = try container.decode(UInt.self)
      self.init(rawValue: intValue)
    }
  }

}
