//
//  Event.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol Event {
    
    var type: EventType { get }
    var name: String { get }
    var indexName: String { get }
    var userToken: String { get }
    var timestamp: Int64 { get }
    var queryID: String? { get }
    var objectIDsOrFilters: ObjectsIDsOrFilters { get }
    
}

protocol CoreEventContainer: Event {
    
    var coreEvent: CoreEvent { get }
    
}

extension CoreEventContainer {
    
    var type: EventType {
        return coreEvent.type
    }
    
    var name: String {
        return coreEvent.name
    }
    
    var indexName: String {
        return coreEvent.indexName
    }
    
    var userToken: String {
        return coreEvent.userToken
    }
    
    var timestamp: Int64 {
        return coreEvent.timestamp
    }
    
    var queryID: String? {
        return coreEvent.queryID
    }
    
    var objectIDsOrFilters: ObjectsIDsOrFilters {
        return coreEvent.objectIDsOrFilters
    }
    
}
