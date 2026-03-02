//
//  TestEventTracker.swift
//
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
@testable import InstantSearchInsights

class TestEventTracker: EventTrackable {
  var didViewObjects: ((String, String, String?, Date?, [String]) -> Void)?
  var didViewFilters: ((String, String, String?, Date?, [String]) -> Void)?
  var didClickObjects: ((String, String, String?, Date?, [String]) -> Void)?
  var didClickObjectsAfterSearch: ((String, String, String?, Date?, [String], [Int], String) -> Void)?
  var didClickFilters: ((String, String, String?, Date?, [String]) -> Void)?
  var didConvertObjects: ((String, String, String?, Date?, [String]) -> Void)?
  var didConvertObjectsAfterSearch: ((String, String, String?, Date?, [String], String) -> Void)?
  var didConvertFilters: ((String, String, String?, Date?, [String]) -> Void)?

  func view(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String]) {
    didViewObjects?(eventName, indexName, userToken, timestamp, objectIDs)
  }

  func view(eventName: String, indexName: String, userToken: String?, timestamp: Date?, filters: [String]) {
    didViewFilters?(eventName, indexName, userToken, timestamp, filters)
  }

  func click(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String]) {
    didClickObjects?(eventName, indexName, userToken, timestamp, objectIDs)
  }

  func click(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], positions: [Int], queryID: String) {
    didClickObjectsAfterSearch?(eventName, indexName, userToken, timestamp, objectIDs, positions, queryID)
  }

  func click(eventName: String, indexName: String, userToken: String?, timestamp: Date?, filters: [String]) {
    didClickFilters?(eventName, indexName, userToken, timestamp, filters)
  }

  func conversion(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String]) {
    didConvertObjects?(eventName, indexName, userToken, timestamp, objectIDs)
  }

  func conversion(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], queryID: String) {
    didConvertObjectsAfterSearch?(eventName, indexName, userToken, timestamp, objectIDs, queryID)
  }

  func conversion(eventName: String, indexName: String, userToken: String?, timestamp: Date?, filters: [String]) {
    didConvertFilters?(eventName, indexName, userToken, timestamp, filters)
  }
}
