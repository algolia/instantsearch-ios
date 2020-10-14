//
//  Region.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class Region: NSObject, RawRepresentable, Codable {
    
    public typealias RawValue = String
    
    public static let us = Region(rawValue: "us")
    public static let de = Region(rawValue: "de")
    
    public let rawValue: String
    
    var urlSuffix: String {
        return ".\(rawValue)"
    }
    
    required public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}
