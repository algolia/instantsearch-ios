//
//  InsightsEvent+Conversion.swift
//  
//
//  Created by Vladislav Fitc on 23/04/2020.
//

import Foundation

public extension InsightsEvent {

  static func conversion(name: EventName,
                         indexName: IndexName,
                         userToken: UserToken?,
                         timestamp: Date? = nil,
                         queryID: QueryID?,
                         objectIDs: [ObjectID]) throws -> Self {
    return try self.init(type: .conversion,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: queryID,
                         resources: .objectIDs(objectIDs))
  }

  static func conversion(name: EventName,
                         indexName: IndexName,
                         userToken: UserToken?,
                         timestamp: Date? = nil,
                         queryID: QueryID?,
                         filters: [String]) throws -> Self {
    return try self.init(type: .conversion,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: queryID,
                         resources: .filters(filters))
  }

}
