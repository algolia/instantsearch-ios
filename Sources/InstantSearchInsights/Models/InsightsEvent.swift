//
//  InsightsEvent.swift
//  InstantSearchInsights
//

import Foundation
import Insights

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
  var eventsItem: EventsItems? {
    switch eventType {
    case .viewedObjectIDs:
      guard let objectIDs else { return nil }
      let event = ViewedObjectIDs(eventName: eventName,
                                  eventType: .view,
                                  index: indexName,
                                  objectIDs: objectIDs,
                                  userToken: userToken,
                                  timestamp: timestamp)
      return .viewedObjectIDs(event)
    case .clickedObjectIDsAfterSearch:
      guard let objectIDs,
            let positions,
            let queryID else { return nil }
      let event = ClickedObjectIDsAfterSearch(eventName: eventName,
                                              eventType: .click,
                                              index: indexName,
                                              objectIDs: objectIDs,
                                              positions: positions,
                                              queryID: queryID,
                                              userToken: userToken,
                                              timestamp: timestamp)
      return .clickedObjectIDsAfterSearch(event)
    case .clickedObjectIDs:
      guard let objectIDs else { return nil }
      let event = ClickedObjectIDs(eventName: eventName,
                                   eventType: .click,
                                   index: indexName,
                                   objectIDs: objectIDs,
                                   userToken: userToken,
                                   timestamp: timestamp)
      return .clickedObjectIDs(event)
    case .convertedObjectIDsAfterSearch:
      guard let objectIDs,
            let queryID else { return nil }
      let event = ConvertedObjectIDsAfterSearch(eventName: eventName,
                                                eventType: .conversion,
                                                index: indexName,
                                                objectIDs: objectIDs,
                                                queryID: queryID,
                                                userToken: userToken,
                                                timestamp: timestamp)
      return .convertedObjectIDsAfterSearch(event)
    case .convertedObjectIDs:
      guard let objectIDs else { return nil }
      let event = ConvertedObjectIDs(eventName: eventName,
                                     eventType: .conversion,
                                     index: indexName,
                                     objectIDs: objectIDs,
                                     userToken: userToken,
                                     timestamp: timestamp)
      return .convertedObjectIDs(event)
    case .viewedFilters:
      guard let filters else { return nil }
      let event = ViewedFilters(eventName: eventName,
                                eventType: .view,
                                index: indexName,
                                filters: filters.map { $0.legacyString() },
                                userToken: userToken,
                                timestamp: timestamp)
      return .viewedFilters(event)
    case .clickedFilters:
      guard let filters else { return nil }
      let event = ClickedFilters(eventName: eventName,
                                 eventType: .click,
                                 index: indexName,
                                 filters: filters.map { $0.legacyString() },
                                 userToken: userToken,
                                 timestamp: timestamp)
      return .clickedFilters(event)
    case .convertedFilters:
      guard let filters else { return nil }
      let event = ConvertedFilters(eventName: eventName,
                                   eventType: .conversion,
                                   index: indexName,
                                   filters: filters.map { $0.legacyString() },
                                   userToken: userToken,
                                   timestamp: timestamp)
      return .convertedFilters(event)
    }
  }
}


