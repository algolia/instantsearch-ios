//
//  GeoHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/10/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol GeoHitsController: AnyObject, Reloadable {

  associatedtype DataSource: HitsSource where DataSource.Record: Geolocated

  var hitsSource: DataSource? { get set }

}
