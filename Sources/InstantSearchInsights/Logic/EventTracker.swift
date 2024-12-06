//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Compat
import Foundation
import Insights

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

  func effectiveUserToken(withEventUserToken eventUserToken: UserToken?) -> String {
    return (eventUserToken ?? userToken ?? Insights.userToken).rawValue
  }

  func effectiveTimestamp(for timestamp: Date?) -> Int64? {
    let value = timestamp ?? (generateTimestamps ? Date() : nil)
    return value.map { Int64($0.timeIntervalSince1970) }
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            timestamp: Date?,
            objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(EventsItems.viewedObjectIDs(ViewedObjectIDs(
        eventName: eventName.rawValue,
        eventType: ViewEvent.view,
        index: indexName.rawValue,
        objectIDs: objectIDs.map { $0.rawValue },
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            timestamp: Date?,
            filters: [String]) {
    do {
      eventProcessor.process(EventsItems.viewedFilters(ViewedFilters(
        eventName: eventName.rawValue,
        eventType: ViewEvent.view,
        index: indexName.rawValue,
        filters: filters,
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken?,
             timestamp: Date?,
             objectIDs: [ObjectID],
             positions: [Int],
             queryID: QueryID) {
    do {
      eventProcessor.process(EventsItems.clickedObjectIDsAfterSearch(ClickedObjectIDsAfterSearch(
        eventName: eventName.rawValue,
        eventType: ClickEvent.click,
        index: indexName.rawValue,
        objectIDs: objectIDs.map { $0.rawValue },
        positions: positions,
        queryID: queryID.rawValue,
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             timestamp: Date?,
             objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(EventsItems.clickedObjectIDs(ClickedObjectIDs(
        eventName: eventName.rawValue,
        eventType: ClickEvent.click,
        index: indexName.rawValue,
        objectIDs: objectIDs.map { $0.rawValue },
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             timestamp: Date?,
             filters: [String]) {
    do {
      eventProcessor.process(EventsItems.clickedFilters(ClickedFilters(
        eventName: eventName.rawValue,
        eventType: ClickEvent.click,
        index: indexName.rawValue,
        filters: filters,
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  timestamp: Date?,
                  objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(EventsItems.convertedObjectIDs(ConvertedObjectIDs(
        eventName: eventName.rawValue,
        eventType: ConversionEvent.conversion,
        index: indexName.rawValue,
        objectIDs: objectIDs.map { $0.rawValue },
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  timestamp: Date?,
                  filters: [String]) {
    do {
      eventProcessor.process(EventsItems.convertedFilters(ConvertedFilters(
        eventName: eventName.rawValue,
        eventType: ConversionEvent.conversion,
        index: indexName.rawValue,
        filters: filters,
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken?,
                  timestamp: Date?,
                  objectIDs: [ObjectID],
                  queryID: QueryID) {
    do {
      eventProcessor.process(EventsItems.convertedObjectIDsAfterSearch(ConvertedObjectIDsAfterSearch(
        eventName: eventName.rawValue,
        eventType: ConversionEvent.conversion,
        index: indexName.rawValue,
        objectIDs: objectIDs.map { $0.rawValue },
        queryID: queryID.rawValue,
        userToken: effectiveUserToken(withEventUserToken: userToken),
        timestamp: effectiveTimestamp(for: timestamp)
      )))
    } catch {
      log(error)
    }
  }

  private func log(_ error: Error) {
    logger.error("\(error.localizedDescription)")
  }
}
// swiftlint:enable function_parameter_count
