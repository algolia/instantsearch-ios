//
//  InsightsEvent+View.swift
//  
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

public extension InsightsEvent {

  static func view(name: EventName,
                   indexName: IndexName,
                   userToken: UserToken?,
                   timestamp: Date? = nil,
                   objectIDs: [ObjectID]) throws -> Self {
    return try self.init(type: .view,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: nil,
                         resources: .objectIDs(objectIDs))
  }

  static func view(name: EventName,
                   indexName: IndexName,
                   userToken: UserToken?,
                   timestamp: Date? = nil,
                   filters: [String]) throws -> Self {
    return try self.init(type: .view,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: nil,
                         resources: .filters(filters))
  }

}
