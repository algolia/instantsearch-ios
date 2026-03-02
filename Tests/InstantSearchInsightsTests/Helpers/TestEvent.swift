//
//  TestEvent.swift
//
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import Foundation
@testable import InstantSearchInsights

struct TestEvent {
  static let eventName: String = "test event name"
  static let indexName: String = "test index"
  static let userToken: String = "testtoken"
  static let queryID: String = "test query id"
  static let timeStamp = Date()
  static let objectIDs: [String] = ["o1", "o2", "o3"]
  static let positions: [Int] = [1, 2, 3]
  static let filters = ["key1:value1", "key2:value2"]
  static let filterFacets = FilterFacet.parseFilters(filters)
  static var objectIDsWithPositions: [(String, Int)] { zip(objectIDs, positions).map { $0 } }

  static var click: InsightsEvent {
    [clickWithFilters, clickWithObjects].randomElement()!
  }

  static var clickWithFilters: InsightsEvent {
    .clickedFilters(eventName: "click event name",
                    indexName: indexName,
                    userToken: userToken,
                    timestamp: timeStamp.millisecondsSince1970,
                    filters: filterFacets)
  }

  static var clickWithObjects: InsightsEvent {
    .clickedObjectIDs(eventName: "click event name",
                      indexName: indexName,
                      userToken: userToken,
                      timestamp: timeStamp.millisecondsSince1970,
                      objectIDs: objectIDs)
  }

  static var viewWithObjects: InsightsEvent {
    .viewedObjectIDs(eventName: "view event name",
                     indexName: indexName,
                     userToken: userToken,
                     timestamp: timeStamp.millisecondsSince1970,
                     objectIDs: objectIDs)
  }

  static var viewWithFilters: InsightsEvent {
    .viewedFilters(eventName: "view event name",
                   indexName: indexName,
                   userToken: userToken,
                   timestamp: timeStamp.millisecondsSince1970,
                   filters: filterFacets)
  }

  static var view: InsightsEvent {
    [viewWithObjects, viewWithFilters].randomElement()!
  }

  static var conversionWithObjects: InsightsEvent {
    .convertedObjectIDsAfterSearch(eventName: "conversion event name",
                                   indexName: indexName,
                                   userToken: userToken,
                                   timestamp: timeStamp.millisecondsSince1970,
                                   queryID: queryID,
                                   objectIDs: objectIDs)
  }

  static var conversionWithFilters: InsightsEvent {
    .convertedFilters(eventName: "conversion event name",
                      indexName: indexName,
                      userToken: userToken,
                      timestamp: timeStamp.millisecondsSince1970,
                      filters: filterFacets)
  }

  static var conversion: InsightsEvent {
    [conversionWithObjects, conversionWithFilters].randomElement()!
  }

  static var random: InsightsEvent {
    [click, view, conversion].randomElement()!
  }
}
