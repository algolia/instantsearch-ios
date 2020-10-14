//
//  Conversion.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct ConversionEvent: CoreEventContainer {
    
    let coreEvent: CoreEvent
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        coreEvent = try CoreEvent(type: .conversion,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: objectIDsOrFilters)
    }
    
}

extension ConversionEvent: Codable {
    
    init(from decoder: Decoder) throws {
        coreEvent = try CoreEvent(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        try coreEvent.encode(to: encoder)
    }
    
}
