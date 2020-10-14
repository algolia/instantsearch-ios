//
//  ClickEvent.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct ClickEvent: CoreEventContainer {
    
    let coreEvent: CoreEvent
    let positions: [Int]?
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String,
         objectIDsWithPositions: [(String, Int)]) throws {
        
        let objectIDs = objectIDsWithPositions.map { $0.0 }
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: .objectIDs(objectIDs))
        self.positions = objectIDsWithPositions.map { $0.1 }
    }
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         objectIDsOrFilters: ObjectsIDsOrFilters,
         positions: [Int]?) throws {
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: .none,
                                  objectIDsOrFilters: objectIDsOrFilters)
        self.positions = positions
    }
    
}

extension ClickEvent: Codable {
    
    enum CodingKeys: String, CodingKey {
        case positions
    }
    
    init(from decoder: Decoder) throws {
        coreEvent = try CoreEvent(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        positions = try container.decodeIfPresent([Int].self, forKey: .positions)
    }
    
    func encode(to encoder: Encoder) throws {
        try coreEvent.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(positions, forKey: .positions)
    }

}
