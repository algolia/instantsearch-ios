//
//  EventsPackage.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct EventsPackage {
    
    static let maxEventCountInPackage = 1000
    static let empty = EventsPackage(region: .none)
    
    let id: String
    let events: [EventWrapper]
    let region: Region?
    
    var isFull: Bool {
        return events.count == EventsPackage.maxEventCountInPackage
    }
    
    init(event: EventWrapper, region: Region? = .none) {
        self.id = UUID().uuidString
        self.events = [event]
        self.region = region
    }
    
    init(region: Region? = .none) {
        self.id = UUID().uuidString
        self.events = []
        self.region = region
    }
    
    init(events: [EventWrapper], region: Region? = .none) throws {
        guard events.count <= EventsPackage.maxEventCountInPackage else {
            throw Error.packageOverflow
        }
        self.id = UUID().uuidString
        self.events = events
        self.region = region
    }
    
    func appending(_ event: EventWrapper) throws -> EventsPackage {
        return try appending([event])
    }
    
    func appending(_ events: [EventWrapper]) throws -> EventsPackage {
        guard events.count + self.events.count <= EventsPackage.maxEventCountInPackage else {
            throw Error.packageOverflow
        }
        return try EventsPackage(events: self.events + events, region: region)
    }
    
}

extension EventsPackage: Collection {
    
    typealias Index = Array<EventWrapper>.Index
    typealias Element = Array<EventWrapper>.Element

    var startIndex: Index {
        return events.startIndex
    }
    
    var endIndex: Index {
        return events.endIndex
    }
    
    func index(after i: Index) -> Index {
        return events.index(after: i)
    }
    
    subscript(index: Index) -> Element {
        get { return events[index] }
    }
    
}

extension EventsPackage {
    
    enum Error: Swift.Error {
        case packageOverflow
    }
    
}

extension EventsPackage.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .packageOverflow:
            return "Max events count in package is \(EventsPackage.maxEventCountInPackage)"
        }
    }
    
}

extension EventsPackage: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case events
        case region
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.events = try container.decode([EventWrapper].self, forKey: .events)
        self.region = try container.decodeIfPresent(Region.self, forKey: .region)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(events, forKey: .events)
        try container.encodeIfPresent(region?.rawValue, forKey: .region)
    }
    
}

extension EventsPackage: Hashable {
    
    static func == (lhs: EventsPackage, rhs: EventsPackage) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension EventsPackage: Syncable {
    
    @discardableResult func sync() -> Resource<Bool, WebserviceError> {
        
        let errorParse: (Int, Any) -> WebserviceError? = { (code, data) -> WebserviceError? in
            if let data = data as? [String: Any],
                let message = data["message"] as? String {
                let error = WebserviceError(code: code, message: message)
                return error
            }
            return nil
        }
        let serializedSelf = [CodingKeys.events.rawValue: Array(encodable: self.events)]
        let url = API.baseAPIURL(forRegion: region)
        return Resource<Bool, WebserviceError>(url: url,
                                               method: .post([], serializedSelf as AnyObject),
                                               allowEmptyResponse: true,
                                               errorParseJSON: errorParse)
    }
    
}
