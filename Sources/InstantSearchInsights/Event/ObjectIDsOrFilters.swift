//
//  ObjectIDsOrFilters.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public enum ObjectsIDsOrFilters: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case objectIDs
        case filters
    }
    
    enum Error: Swift.Error {
        case decodingFailure
    }
    
    case objectIDs([String])
    case filters([String])
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let objectIDs = try? container.decode([String].self, forKey: .objectIDs) {
            self = .objectIDs(objectIDs)
        } else if let filters = try? container.decode([String].self, forKey: .filters) {
            self = .filters(filters)
        } else {
            throw Error.decodingFailure
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .filters(let filters):
            try container.encode(filters, forKey: .filters)
            
        case .objectIDs(let objectsIDs):
            try container.encode(objectsIDs, forKey: .objectIDs)
        }
        
    }
    
}

extension ObjectsIDsOrFilters.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "Neither \(ObjectsIDsOrFilters.CodingKeys.filters.rawValue), nor \(ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue) key found on decoder"
        }
    }
    
}
