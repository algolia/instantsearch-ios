//
//  AroundPrecision.swift
//  
//
//  Created by Vladislav Fitc on 23/03/2020.
//

import Foundation

public struct AroundPrecision: Codable, Equatable {

  public let from: Int
  public let value: Int

  public init(from: Int, value: Int) {
    self.from = from
    self.value = value
  }

}

extension AroundPrecision: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self.from = 0
    self.value = value
  }

}

extension AroundPrecision: ExpressibleByFloatLiteral {

  public init(floatLiteral value: Double) {
    self.from = 0
    self.value = Int(value)
  }

}

extension AroundPrecision: URLEncodable {

  public var urlEncodedString: String {
    return "{\"from\":\(from),\"value\":\(value)}"
  }

}
