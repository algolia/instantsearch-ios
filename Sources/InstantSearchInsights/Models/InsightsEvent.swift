//
//  InsightsEvent.swift
//  InstantSearchInsights
//

import Foundation
import AlgoliaInsights

public struct InsightsEvent: Codable, Hashable {
  public enum EventType: String, Codable {
    case viewedObjectIDs
    case clickedObjectIDsAfterSearch
    case clickedObjectIDs
    case convertedObjectIDsAfterSearch
    case convertedObjectIDs
    case viewedFilters
    case clickedFilters
    case convertedFilters
    case purchasedObjectIDsAfterSearch
    case purchasedObjectIDs
    case addedToCartObjectIDsAfterSearch
    case addedToCartObjectIDs
  }

  public let eventType: EventType
  public let eventName: String
  public let indexName: String
  public let userToken: String
  public let timestamp: Int64?
  public let objectIDs: [String]?
  public let positions: [Int]?
  public let queryID: String?
  public let filters: [FilterFacet]?
  public let currency: String?
  public let objectData: [ObjectData]?
  public let objectDataAfterSearch: [ObjectDataAfterSearch]?
  public let value: InsightsValue?

  public init(eventType: EventType,
              eventName: String,
              indexName: String,
              userToken: String,
              timestamp: Int64? = nil,
              objectIDs: [String]? = nil,
              positions: [Int]? = nil,
              queryID: String? = nil,
              filters: [FilterFacet]? = nil,
              currency: String? = nil,
              objectData: [ObjectData]? = nil,
              objectDataAfterSearch: [ObjectDataAfterSearch]? = nil,
              value: InsightsValue? = nil) {
    self.eventType = eventType
    self.eventName = eventName
    self.indexName = indexName
    self.userToken = userToken
    self.timestamp = timestamp
    self.objectIDs = objectIDs
    self.positions = positions
    self.queryID = queryID
    self.filters = filters
    self.currency = currency
    self.objectData = objectData
    self.objectDataAfterSearch = objectDataAfterSearch
    self.value = value
  }
}

public extension InsightsEvent {
  static func viewedObjectIDs(eventName: String,
                              indexName: String,
                              userToken: String,
                              timestamp: Int64?,
                              objectIDs: [String]) -> InsightsEvent {
    return .init(eventType: .viewedObjectIDs,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs)
  }

  static func clickedObjectIDsAfterSearch(eventName: String,
                                          indexName: String,
                                          userToken: String,
                                          timestamp: Int64?,
                                          queryID: String,
                                          objectIDsWithPositions: [(String, Int)]) -> InsightsEvent {
    return .init(eventType: .clickedObjectIDsAfterSearch,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDsWithPositions.map(\.0),
                 positions: objectIDsWithPositions.map(\.1),
                 queryID: queryID)
  }

  static func clickedObjectIDs(eventName: String,
                               indexName: String,
                               userToken: String,
                               timestamp: Int64?,
                               objectIDs: [String]) -> InsightsEvent {
    return .init(eventType: .clickedObjectIDs,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs)
  }

  static func convertedObjectIDsAfterSearch(eventName: String,
                                            indexName: String,
                                            userToken: String,
                                            timestamp: Int64?,
                                            queryID: String,
                                            objectIDs: [String]) -> InsightsEvent {
    return .init(eventType: .convertedObjectIDsAfterSearch,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs,
                 queryID: queryID)
  }

  static func convertedObjectIDs(eventName: String,
                                 indexName: String,
                                 userToken: String,
                                 timestamp: Int64?,
                                 objectIDs: [String]) -> InsightsEvent {
    return .init(eventType: .convertedObjectIDs,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs)
  }

  static func viewedFilters(eventName: String,
                            indexName: String,
                            userToken: String,
                            timestamp: Int64?,
                            filters: [FilterFacet]) -> InsightsEvent {
    return .init(eventType: .viewedFilters,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 filters: filters)
  }

  static func clickedFilters(eventName: String,
                             indexName: String,
                             userToken: String,
                             timestamp: Int64?,
                             filters: [FilterFacet]) -> InsightsEvent {
    return .init(eventType: .clickedFilters,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 filters: filters)
  }

  static func convertedFilters(eventName: String,
                               indexName: String,
                               userToken: String,
                               timestamp: Int64?,
                               filters: [FilterFacet]) -> InsightsEvent {
    return .init(eventType: .convertedFilters,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 filters: filters)
  }

  static func purchasedObjectIDsAfterSearch(eventName: String,
                                            indexName: String,
                                            userToken: String,
                                            timestamp: Int64?,
                                            queryID: String,
                                            objectIDs: [String],
                                            objectDataAfterSearch: [ObjectDataAfterSearch],
                                            currency: String? = nil,
                                            value: InsightsValue? = nil) -> InsightsEvent {
    return .init(eventType: .purchasedObjectIDsAfterSearch,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs,
                 queryID: queryID,
                 objectDataAfterSearch: objectDataAfterSearch,
                 value: value)
  }

  static func purchasedObjectIDs(eventName: String,
                                 indexName: String,
                                 userToken: String,
                                 timestamp: Int64?,
                                 objectIDs: [String],
                                 objectData: [ObjectData]? = nil,
                                 currency: String? = nil,
                                 value: InsightsValue? = nil) -> InsightsEvent {
    return .init(eventType: .purchasedObjectIDs,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs,
                 currency: currency,
                 objectData: objectData,
                 value: value)
  }

  static func addedToCartObjectIDsAfterSearch(eventName: String,
                                              indexName: String,
                                              userToken: String,
                                              timestamp: Int64?,
                                              queryID: String,
                                              objectIDs: [String],
                                              objectDataAfterSearch: [ObjectDataAfterSearch]? = nil,
                                              currency: String? = nil,
                                              value: InsightsValue? = nil) -> InsightsEvent {
    return .init(eventType: .addedToCartObjectIDsAfterSearch,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs,
                 queryID: queryID,
                 objectDataAfterSearch: objectDataAfterSearch,
                 value: value)
  }

  static func addedToCartObjectIDs(eventName: String,
                                   indexName: String,
                                   userToken: String,
                                   timestamp: Int64?,
                                   objectIDs: [String],
                                   objectData: [ObjectData]? = nil,
                                   currency: String? = nil,
                                   value: InsightsValue? = nil) -> InsightsEvent {
    return .init(eventType: .addedToCartObjectIDs,
                 eventName: eventName,
                 indexName: indexName,
                 userToken: userToken,
                 timestamp: timestamp,
                 objectIDs: objectIDs,
                 currency: currency,
                 objectData: objectData,
                 value: value)
  }
}

extension InsightsEvent {
  private var filterStrings: [String]? {
    filters?.map { $0.legacyString() }
  }

  var eventsItem: EventsItems? {
    switch eventType {
    case .viewedObjectIDs:
      guard let objectIDs else { return nil }
      return .viewedObjectIDs(ViewedObjectIDs(
        eventName: eventName, eventType: .view, index: indexName,
        objectIDs: objectIDs, userToken: userToken, timestamp: timestamp))
    case .clickedObjectIDsAfterSearch:
      guard let objectIDs, let positions, let queryID else { return nil }
      return .clickedObjectIDsAfterSearch(ClickedObjectIDsAfterSearch(
        eventName: eventName, eventType: .click, index: indexName,
        objectIDs: objectIDs, positions: positions, queryID: queryID,
        userToken: userToken, timestamp: timestamp))
    case .clickedObjectIDs:
      guard let objectIDs else { return nil }
      return .clickedObjectIDs(ClickedObjectIDs(
        eventName: eventName, eventType: .click, index: indexName,
        objectIDs: objectIDs, userToken: userToken, timestamp: timestamp))
    case .convertedObjectIDsAfterSearch:
      guard let objectIDs, let queryID else { return nil }
      return .convertedObjectIDsAfterSearch(ConvertedObjectIDsAfterSearch(
        eventName: eventName, eventType: .conversion, index: indexName,
        objectIDs: objectIDs, queryID: queryID, userToken: userToken, timestamp: timestamp))
    case .convertedObjectIDs:
      guard let objectIDs else { return nil }
      return .convertedObjectIDs(ConvertedObjectIDs(
        eventName: eventName, eventType: .conversion, index: indexName,
        objectIDs: objectIDs, userToken: userToken, timestamp: timestamp))
    case .viewedFilters:
      guard let filterStrings else { return nil }
      return .viewedFilters(ViewedFilters(
        eventName: eventName, eventType: .view, index: indexName,
        filters: filterStrings, userToken: userToken, timestamp: timestamp))
    case .clickedFilters:
      guard let filterStrings else { return nil }
      return .clickedFilters(ClickedFilters(
        eventName: eventName, eventType: .click, index: indexName,
        filters: filterStrings, userToken: userToken, timestamp: timestamp))
    case .convertedFilters:
      guard let filterStrings else { return nil }
      return .convertedFilters(ConvertedFilters(
        eventName: eventName, eventType: .conversion, index: indexName,
        filters: filterStrings, userToken: userToken, timestamp: timestamp))
    case .purchasedObjectIDsAfterSearch:
      guard let objectIDs, let objectDataAfterSearch else { return nil }
      return .purchasedObjectIDsAfterSearch(PurchasedObjectIDsAfterSearch(
        eventName: eventName, eventType: .conversion, eventSubtype: .purchase, index: indexName,
        objectIDs: objectIDs, userToken: userToken, currency: currency,
        objectData: objectDataAfterSearch, timestamp: timestamp, value: value))
    case .purchasedObjectIDs:
      guard let objectIDs else { return nil }
      return .purchasedObjectIDs(PurchasedObjectIDs(
        eventName: eventName, eventType: .conversion, eventSubtype: .purchase, index: indexName,
        objectIDs: objectIDs, userToken: userToken, currency: currency,
        objectData: objectData, timestamp: timestamp, value: value))
    case .addedToCartObjectIDsAfterSearch:
      guard let objectIDs, let queryID else { return nil }
      return .addedToCartObjectIDsAfterSearch(AddedToCartObjectIDsAfterSearch(
        eventName: eventName, eventType: .conversion, eventSubtype: .addToCart, index: indexName,
        queryID: queryID, objectIDs: objectIDs, userToken: userToken, currency: currency,
        objectData: objectDataAfterSearch, timestamp: timestamp, value: value))
    case .addedToCartObjectIDs:
      guard let objectIDs else { return nil }
      return .addedToCartObjectIDs(AddedToCartObjectIDs(
        eventName: eventName, eventType: .conversion, eventSubtype: .addToCart, index: indexName,
        objectIDs: objectIDs, userToken: userToken, currency: currency,
        objectData: objectData, timestamp: timestamp, value: value))
    }
  }
}
