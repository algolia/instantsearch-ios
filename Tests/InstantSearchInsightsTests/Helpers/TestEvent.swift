//
//  TestEvent.swift
//
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import AlgoliaInsights
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

  static let objectDataItems: [ObjectData] = [
    ObjectData(price: .double(9.99), quantity: 1),
    ObjectData(price: .double(19.99), quantity: 2),
    ObjectData(price: .double(29.99), quantity: 1)
  ]

  static let objectDataAfterSearchItems: [ObjectDataAfterSearch] = [
    ObjectDataAfterSearch(queryID: queryID, price: .double(9.99), quantity: 1),
    ObjectDataAfterSearch(queryID: queryID, price: .double(19.99), quantity: 2),
    ObjectDataAfterSearch(queryID: queryID, price: .double(29.99), quantity: 1)
  ]

  static let currency: String = "USD"

  static var purchasedWithObjects: InsightsEvent {
    .purchasedObjectIDs(eventName: "purchase event name",
                        indexName: indexName,
                        userToken: userToken,
                        timestamp: timeStamp.millisecondsSince1970,
                        objectIDs: objectIDs,
                        objectData: objectDataItems,
                        currency: currency)
  }

  static var purchasedAfterSearch: InsightsEvent {
    .purchasedObjectIDsAfterSearch(eventName: "purchase event name",
                                   indexName: indexName,
                                   userToken: userToken,
                                   timestamp: timeStamp.millisecondsSince1970,
                                   queryID: queryID,
                                   objectIDs: objectIDs,
                                   objectDataAfterSearch: objectDataAfterSearchItems,
                                   currency: currency)
  }

  static var addedToCartWithObjects: InsightsEvent {
    .addedToCartObjectIDs(eventName: "add to cart event name",
                          indexName: indexName,
                          userToken: userToken,
                          timestamp: timeStamp.millisecondsSince1970,
                          objectIDs: objectIDs,
                          objectData: objectDataItems,
                          currency: currency)
  }

  static var addedToCartAfterSearch: InsightsEvent {
    .addedToCartObjectIDsAfterSearch(eventName: "add to cart event name",
                                     indexName: indexName,
                                     userToken: userToken,
                                     timestamp: timeStamp.millisecondsSince1970,
                                     queryID: queryID,
                                     objectIDs: objectIDs,
                                     objectDataAfterSearch: objectDataAfterSearchItems,
                                     currency: currency)
  }

  static var random: InsightsEvent {
    [click, view, conversion].randomElement()!
  }
}
