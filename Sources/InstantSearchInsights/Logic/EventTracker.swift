//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import AlgoliaSearchClient
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
    do {
      eventProcessor.process(try .view(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: effectiveTimestamp(for: timestamp),
                                       objectIDs: objectIDs))
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
      eventProcessor.process(try .view(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: effectiveTimestamp(for: timestamp),
                                       filters: filters))
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
      let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: effectiveTimestamp(for: timestamp),
                                        queryID: queryID,
                                        objectIDsWithPositions: objectIDsWithPositions))
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
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: effectiveTimestamp(for: timestamp),
                                        objectIDs: objectIDs))
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
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: effectiveTimestamp(for: timestamp),
                                        filters: filters))
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
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: effectiveTimestamp(for: timestamp),
                                             queryID: nil,
                                             objectIDs: objectIDs))
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
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: effectiveTimestamp(for: timestamp),
                                             queryID: nil,
                                             filters: filters))
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
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: effectiveTimestamp(for: timestamp),
                                             queryID: queryID,
                                             objectIDs: objectIDs))
    } catch {
      log(error)
    }
  }

  private func log(_ error: Error) {
    logger.error("\(error.localizedDescription)")
  }
}
// swiftlint:enable function_parameter_count
