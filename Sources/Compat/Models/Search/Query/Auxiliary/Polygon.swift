//
//  Polygon.swift
//  
//
//  Created by Vladislav Fitc on 21/03/2020.
//

import Foundation

public struct Polygon: Equatable {

  public let points: [Point]

  public init(points: [Point]) {
    self.points = points
  }

  public init(_ point1: Point, _ point2: Point, _ point3: Point, _ points: Point...) {
    self.init(point1, point2, point3, points)
  }

  public init(_ point1: (Double, Double), _ point2: (Double, Double), _ point3: (Double, Double), _ points: (Double, Double)...) {
    let point1 = Point(latitude: point1.0, longitude: point1.1)
    let point2 = Point(latitude: point2.0, longitude: point2.1)
    let point3 = Point(latitude: point3.0, longitude: point3.1)
    let points = points.map { Point(latitude: $0.0, longitude: $0.1) }
    self.init(point1, point2, point3, points)
  }

  init(_ point1: Point, _ point2: Point, _ point3: Point, _ points: [Point]) {
    self.points = [point1, point2, point3] + points
  }

}

extension Polygon: RawRepresentable {

  public var rawValue: [Double] {
    return points.map(\.rawValue).flatMap { $0 }
  }

  public init?(rawValue: [Double]) {
    guard rawValue.count >= 6 else { return nil }

    let tailPoints: [Point]

    if rawValue.count == 6 {
      tailPoints = []
    } else {
      tailPoints = stride(from: rawValue.startIndex.advanced(by: 6), to: rawValue.endIndex, by: 2).map { Point(latitude: rawValue[$0], longitude: rawValue[$0+1]) }
    }

    self.init(.init(latitude: rawValue[0], longitude: rawValue[1]),
              .init(latitude: rawValue[2], longitude: rawValue[3]),
              .init(latitude: rawValue[4], longitude: rawValue[5]),
              tailPoints)
  }

}

extension Polygon: Codable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode([Double].self)
    guard let value = Polygon(rawValue: rawValue) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Polygon may be constructed with at least 6 double values. \(rawValue.count) found")
    }
    self = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }

}

extension Polygon: URLEncodable {

  public var urlEncodedString: String {
    return "[\(rawValue.map(\.urlEncodedString).joined(separator: ","))]"
  }

}
