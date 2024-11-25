//
//  AroundRadius.swift
//  
//
//  Created by Vladislav Fitc on 20/03/2020.
//

import Foundation

/**
 Define the maximum radius for a geo search (in meters).
 - This setting only works within the context of a radial (circular) geo search, enabled by aroundLatLngViaIP or aroundLatLng.
 */
public enum AroundRadius: Codable, Equatable, URLEncodable {

  /**
   Disables the radius logic, allowing all results to be returned, regardless of distance.
   Ranking is still based on proximity to the central axis point. This option is faster than specifying a high integer value.
  */
  case all

  /**
   Integer value (in meters) representing the radius around the coordinates specified during the query.
   */
  case meters(Int)

  case other(String)
}

extension AroundRadius: RawRepresentable {

  public var rawValue: String {
    switch self {
    case .all:
      return "all"
    case .meters(let meters):
      return "\(meters)"
    case .other(let rawValue):
      return rawValue
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case AroundRadius.all.rawValue:
      self = .all
    case _ where Int(rawValue) != nil:
      self = .meters(Int(rawValue)!)
    default:
      self = .other(rawValue)
    }
  }

}
