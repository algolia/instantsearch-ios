//
//  Point+CoreLocation.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import CoreLocation

/// Simple latitude/longitude point used by geolocation helpers.
public struct Point: Codable, Hashable {
  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}

public extension Point {
  init(_ coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}

public extension CLLocationCoordinate2D {
  init(_ geolocation: Point) {
    self.init(latitude: geolocation.latitude, longitude: geolocation.longitude)
  }
}

public extension CLLocation {
  convenience init(_ geolocation: Point) {
    self.init(latitude: geolocation.latitude, longitude: geolocation.longitude)
  }
}
