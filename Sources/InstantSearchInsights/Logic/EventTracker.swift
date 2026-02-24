//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
// swiftlint:disable function_parameter_count

/// Provides convenient functions for tracking events which can be used for search personalization.
///

class EventTracker: EventTrackable {
  var eventProcessor: EventProcessable
  var logger: Logger
  var userToken: UserToken?
  var generateTimestamps: Bool

  init(eventProcessor: EventProcessable,
       logger: Logger,
       userToken: UserToken?,
       generateTimestamps: Bool) {
    self.eventProcessor = eventProcessor
    self.logger = logger
    self.userToken = userToken
    self.generateTimestamps = generateTimestamps
    InstantSearchInsightsLog.subscribeForLogLevelChange { [weak self] logLevel in
      self?.logger.logLevel = logLevel
    }
  }

  /// Provides an appropriate user token
  /// There are three user tokens levels
  /// 1) Global automatically created app user token
  /// 2) Per-app user token
  /// 3) Per-event user token
  /// The propagation starts from the deepest level and switches to the previous one in case of nil value on the current level.

  func effectiveUserToken(withEventUserToken eventUserToken: UserToken?) -> UserToken {
    return eventUserToken ?? userToken ?? Insights.userToken
  }

  func effectiveTimestamp(for timestamp: Date?) -> Date? {
    return timestamp ?? (generateTimestamps ? Date() : nil)
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            timestamp: Date?,
            objectIDs: [ObjectID]) {
    let event = InsightsEvent.viewedObjectIDs(eventName: eventName,
                                              indexName: indexName,
                                              userToken: effectiveUserToken(withEventUserToken: userToken),
                                              timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                              objectIDs: objectIDs)
    eventProcessor.process(event)
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            timestamp: Date?,
            filters: [String]) {
    let facets = FilterFacet.parseFilters(filters)
    let event = InsightsEvent.viewedFilters(eventName: eventName,
                                            indexName: indexName,
                                            userToken: effectiveUserToken(withEventUserToken: userToken),
                                            timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                            filters: facets)
    eventProcessor.process(event)
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken?,
             timestamp: Date?,
             objectIDs: [ObjectID],
             positions: [Int],
             queryID: QueryID) {
    let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
    let event = InsightsEvent.clickedObjectIDsAfterSearch(eventName: eventName,
                                                          indexName: indexName,
                                                          userToken: effectiveUserToken(withEventUserToken: userToken),
                                                          timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                                          queryID: queryID,
                                                          objectIDsWithPositions: objectIDsWithPositions)
    eventProcessor.process(event)
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             timestamp: Date?,
             objectIDs: [ObjectID]) {
    let event = InsightsEvent.clickedObjectIDs(eventName: eventName,
                                               indexName: indexName,
                                               userToken: effectiveUserToken(withEventUserToken: userToken),
                                               timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                               objectIDs: objectIDs)
    eventProcessor.process(event)
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             timestamp: Date?,
             filters: [String]) {
    let facets = FilterFacet.parseFilters(filters)
    let event = InsightsEvent.clickedFilters(eventName: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                             filters: facets)
    eventProcessor.process(event)
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  timestamp: Date?,
                  objectIDs: [ObjectID]) {
    let event = InsightsEvent.convertedObjectIDs(eventName: eventName,
                                                 indexName: indexName,
                                                 userToken: effectiveUserToken(withEventUserToken: userToken),
                                                 timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                                 objectIDs: objectIDs)
    eventProcessor.process(event)
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  timestamp: Date?,
                  filters: [String]) {
    let facets = FilterFacet.parseFilters(filters)
    let event = InsightsEvent.convertedFilters(eventName: eventName,
                                               indexName: indexName,
                                               userToken: effectiveUserToken(withEventUserToken: userToken),
                                               timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                               filters: facets)
    eventProcessor.process(event)
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken?,
                  timestamp: Date?,
                  objectIDs: [ObjectID],
                  queryID: QueryID) {
    let event = InsightsEvent.convertedObjectIDsAfterSearch(eventName: eventName,
                                                            indexName: indexName,
                                                            userToken: effectiveUserToken(withEventUserToken: userToken),
                                                            timestamp: effectiveTimestamp(for: timestamp)?.millisecondsSince1970,
                                                            queryID: queryID,
                                                            objectIDs: objectIDs)
    eventProcessor.process(event)
  }

  private func log(_ error: Error) {
    logger.error("\(error.localizedDescription)")
  }
}
// swiftlint:enable function_parameter_count
