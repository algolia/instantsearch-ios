//
//  EventWrapper.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

internal enum EventWrapper: Codable {
    
    case click(ClickEvent)
    case view(ViewEvent)
    case conversion(ConversionEvent)
    case custom(Event)
    
    init(_ event: Event) {
        
        switch event {
        case let click as ClickEvent:
            self = .click(click)
        case let view as ViewEvent:
            self = .view(view)
        case let conversion as ConversionEvent:
            self = .conversion(conversion)
        default:
            self = .custom(event)
        }
        
    }
    
    public init(from decoder: Decoder) throws {
        
        let keyedContainer = try decoder.container(keyedBy: CoreEvent.CodingKeys.self)
        
        let type = try keyedContainer.decode(EventType.self, forKey: CoreEvent.CodingKeys.type)
        
        let valueContainer = try decoder.singleValueContainer()
        
        switch type {
        case .click:
            self = .click(try valueContainer.decode(ClickEvent.self))
        case .view:
            self = .view(try valueContainer.decode(ViewEvent.self))
        case .conversion:
            self = .conversion(try valueContainer.decode(ConversionEvent.self))
        default:
            self = .custom(try valueContainer.decode(CoreEvent.self))
        }

    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        switch self {
        case .click(let click):
            try container.encode(click)
        case .conversion(let conversion):
            try container.encode(conversion)
        case .view(let view):
            try container.encode(view)
        case .custom(let event):
            try container.encode(CoreEvent(event: event))
        }
        
    }

}

extension EventWrapper: CustomStringConvertible {
    
    var description: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return String(describing: jsonObject)
        } catch _ {
            return "[encoding error]"
        }
    }
    
}
