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

  public init(eventType: EventType,
              eventName: String,
              indexName: String,
              userToken: String,
              timestamp: Int64? = nil,
              objectIDs: [String]? = nil,
              positions: [Int]? = nil,
              queryID: String? = nil,
              filters: [FilterFacet]? = nil) {
    self.eventType = eventType
    self.eventName = eventName
    self.indexName = indexName
    self.userToken = userToken
    self.timestamp = timestamp
    self.objectIDs = objectIDs
    self.positions = positions
    self.queryID = queryID
    self.filters = filters
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
    }
  }
}
