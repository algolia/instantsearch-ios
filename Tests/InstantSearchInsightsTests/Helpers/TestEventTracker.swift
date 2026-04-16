//
//  TestEventTracker.swift
//
//
//  Created by Vladislav Fitc on 15/10/2020.
//

import AlgoliaInsights
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
  var didPurchaseObjects: ((String, String, String?, Date?, [String], [ObjectData]?, String?, InsightsValue?) -> Void)?
  var didPurchaseObjectsAfterSearch: ((String, String, String?, Date?, [String], [ObjectDataAfterSearch], String, String?, InsightsValue?) -> Void)?
  var didAddToCartObjects: ((String, String, String?, Date?, [String], [ObjectData]?, String?, InsightsValue?) -> Void)?
  var didAddToCartObjectsAfterSearch: ((String, String, String?, Date?, [String], [ObjectDataAfterSearch]?, String, String?, InsightsValue?) -> Void)?

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

  func purchase(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], objectData: [ObjectData]?, currency: String?, value: InsightsValue?) {
    didPurchaseObjects?(eventName, indexName, userToken, timestamp, objectIDs, objectData, currency, value)
  }

  func purchase(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], objectDataAfterSearch: [ObjectDataAfterSearch], queryID: String, currency: String?, value: InsightsValue?) {
    didPurchaseObjectsAfterSearch?(eventName, indexName, userToken, timestamp, objectIDs, objectDataAfterSearch, queryID, currency, value)
  }

  func addToCart(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], objectData: [ObjectData]?, currency: String?, value: InsightsValue?) {
    didAddToCartObjects?(eventName, indexName, userToken, timestamp, objectIDs, objectData, currency, value)
  }

  func addToCart(eventName: String, indexName: String, userToken: String?, timestamp: Date?, objectIDs: [String], objectDataAfterSearch: [ObjectDataAfterSearch]?, queryID: String, currency: String?, value: InsightsValue?) {
    didAddToCartObjectsAfterSearch?(eventName, indexName, userToken, timestamp, objectIDs, objectDataAfterSearch, queryID, currency, value)
  }
}
