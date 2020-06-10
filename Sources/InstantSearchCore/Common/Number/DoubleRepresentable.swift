//
//  DoubleRepresentable.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol DoubleRepresentable {

  init(_ double: Double)
  func toDouble() -> Double
}

extension Int: DoubleRepresentable {
  public func toDouble() -> Double {
    return Double(self)
  }
}

extension UInt: DoubleRepresentable {
  public func toDouble() -> Double {
    return Double(self)
  }
}

extension Float: DoubleRepresentable {
  public func toDouble() -> Double {
    return Double(self)
  }
}

extension Double: DoubleRepresentable {
  public func toDouble() -> Double {
    return Double(self)
  }
}
