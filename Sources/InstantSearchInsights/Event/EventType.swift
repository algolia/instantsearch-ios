//
//  EventType.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public struct EventType: RawRepresentable, ExpressibleByStringLiteral, Equatable, Codable, Hashable {
    
    public typealias StringLiteralType = String
    public typealias RawValue = String
    
    static let click: EventType = "click"
    static let view: EventType = "view"
    static let conversion: EventType = "conversion"
    
    public let rawValue: String
    
    public init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
    
}
