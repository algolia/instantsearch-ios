//
//  TestEventTracker.swift
//  
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
import AlgoliaSearchClient
@testable import InstantSearchInsights

class TestEventTracker: EventTrackable {
  
  var didViewObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didViewFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  var didClickObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didClickObjectsAfterSearch: ((EventName, IndexName, UserToken?, [ObjectID], [Int], QueryID) -> Void)?
  var didClickFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  var didConvertObjects: ((EventName, IndexName, UserToken?, [ObjectID]) -> Void)?
  var didConvertObjectsAfterSearch: ((EventName, IndexName, UserToken?, [ObjectID], QueryID) -> Void)?
  var didConvertFilters: ((EventName, IndexName, UserToken?, [String]) -> Void)?
  
  func view(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didViewObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func view(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didViewFilters?(eventName, indexName, userToken, filters)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didClickObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID], positions: [Int], queryID: QueryID) {
    didClickObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, positions, queryID)
  }
  
  func click(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didClickFilters?(eventName, indexName, userToken, filters)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID]) {
    didConvertObjects?(eventName, indexName, userToken, objectIDs)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, objectIDs: [ObjectID], queryID: QueryID) {
    didConvertObjectsAfterSearch?(eventName, indexName, userToken, objectIDs, queryID)
  }
  
  func conversion(eventName: EventName, indexName: IndexName, userToken: UserToken?, filters: [String]) {
    didConvertFilters?(eventName, indexName, userToken, filters)
  }
  
}
