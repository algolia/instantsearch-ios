//
//  GeoLocation.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct GeoLocation: Codable, RawRepresentable {

    public typealias RawValue = String

    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public init?(rawValue: RawValue) {
        let components = rawValue.split(separator: ",")
        guard
            components.count == 2,
            let latitude = Double(components[0]),
            let longitude = Double(components[1]) else
        {
            return nil
        }
        self.init(latitude: latitude, longitude: longitude)
    }

    public var rawValue: String {
        return "\(latitude),\(longitude)"
    }

}
