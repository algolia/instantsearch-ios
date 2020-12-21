//
//  Geolocated.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/10/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol Geolocated {
  var geolocation: SingleOrList<Point>? { get }
}
