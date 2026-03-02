//
//  Geolocated.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/10/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Represents either a single value or a list of values.
public enum SingleOrList<T: Codable>: Codable {
  case single(T)
  case list([T])

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let list = try? container.decode([T].self) {
      self = .list(list)
    } else {
      self = .single(try container.decode(T.self))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case let .single(value):
      try container.encode(value)
    case let .list(values):
      try container.encode(values)
    }
  }
}

extension SingleOrList: Equatable where T: Equatable {}
extension SingleOrList: Hashable where T: Hashable {}

public protocol Geolocated {
  var geolocation: SingleOrList<Point>? { get }
}
