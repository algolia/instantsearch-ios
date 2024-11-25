//
//  BoundingBox.swift
//  
//
//  Created by Vladislav Fitc on 20/03/2020.
//

import Foundation

/**
 Search inside a rectangular area (in geo coordinates).
 The rectangle is defined by two diagonally opposite points (hereafter [point1] and [point2]).
*/

public struct BoundingBox: Equatable {

  public let point1: Point
  public let point2: Point

  public init(point1: Point, point2: Point) {
    self.point1 = point1
    self.point2 = point2
  }

}

extension BoundingBox {

  public init(point1: (Double, Double), point2: (Double, Double)) {
    self.init(point1: .init(latitude: point1.0,
                            longitude: point1.1),
              point2: .init(latitude: point2.0,
                            longitude: point2.1))
  }

}

extension BoundingBox: RawRepresentable {

  public var rawValue: [Double] {
    return [point1, point2].map(\.rawValue).flatMap { $0 }
  }

  public init?(rawValue: [Double]) {
    guard rawValue.count >= 4 else { return nil }
    let point1 = Point(rawValue: Array(rawValue[0...1]))!
    let point2 = Point(rawValue: Array(rawValue[2...3]))!
    self = .init(point1: point1, point2: point2)
  }

}

extension BoundingBox: Codable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode([Double].self)
    guard let value = BoundingBox(rawValue: rawValue) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "BoundingBox may be constructed with at least 4 double values. \(rawValue.count) found")
    }
    self = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }

}

extension BoundingBox: URLEncodable {

  public var urlEncodedString: String {
    return "[\(rawValue.map(\.urlEncodedString).joined(separator: ","))]"
  }

}
