//
//  TestEvent.swift
//
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Search
import Foundation

struct TestEvent {
  static let eventName: EventName = "test event name"
  static let indexName: IndexName = "test index"
  static let userToken: UserToken = "testtoken"
  static let queryID: QueryID = "test query id"
  static let timeStamp = Date()
  static let objectIDs: [ObjectID] = ["o1", "o2", "o3"]
  static let positions: [Int] = [1, 2, 3]
  static let filters = ["key1:value1", "key2:value2"]
  static var objectIDsWithPositions: [(ObjectID, Int)] { zip(objectIDs, positions).map { $0 } }

  static var click: InsightsEvent {
    [clickWithFilters, clickWithObjects].randomElement()!
  }

  static var clickWithFilters: InsightsEvent {
    try! .click(name: "click event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, filters: filters)
  }

  static var clickWithObjects: InsightsEvent {
    try! .click(name: "click event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, objectIDs: objectIDs)
  }

  static var viewWithObjects: InsightsEvent {
    try! .view(name: "view event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, objectIDs: objectIDs)
  }

  static var viewWithFilters: InsightsEvent {
    try! .view(name: "view event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, filters: filters)
  }

  static var view: InsightsEvent {
    [viewWithObjects, viewWithFilters].randomElement()!
  }

  static var conversionWithObjects: InsightsEvent {
    try! .conversion(name: "conversion event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, queryID: queryID, objectIDs: objectIDs)
  }

  static var conversionWithFilters: InsightsEvent {
    try! .conversion(name: "conversion event name", indexName: indexName, userToken: userToken, timestamp: timeStamp, queryID: queryID, filters: filters)
  }

  static var conversion: InsightsEvent {
    [conversionWithObjects, conversionWithFilters].randomElement()!
  }

  static var random: InsightsEvent {
    [click, view, conversion].randomElement()!
  }
}
