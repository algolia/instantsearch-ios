//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
// swiftlint:disable function_parameter_count

/// Provides convenient functions for tracking events which can be used for search personalization.
///

class EventTracker: NSObject, EventTrackable {

  var eventProcessor: EventProcessable
  var logger: PrefixedLogger
  var userToken: UserToken?

  init(eventProcessor: EventProcessable,
       logger: PrefixedLogger,
       userToken: UserToken? = .none) {
    self.eventProcessor = eventProcessor
    self.logger = logger
    self.userToken = userToken
  }

  /// Provides an appropriate user token
  /// There are three user tokens levels
  /// 1) Global automatically created app user token
  /// 2) Per-app user token
  /// 3) Per-event user token
  /// The propagation starts from the deepest level and switches to the previous one in case of nil value on the current level.

  func effectiveUserToken(withEventUserToken eventUserToken: UserToken?) -> UserToken {
    return eventUserToken ?? self.userToken ?? Insights.userToken
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(try .view(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: Date(),
                                       objectIDs: objectIDs))
    } catch let error {
      logger.error(error)
    }
  }

  func view(eventName: EventName,
            indexName: IndexName,
            userToken: UserToken? = .none,
            filters: [String]) {
    do {
      eventProcessor.process(try .view(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: Date(),
                                       filters: filters))
    } catch let error {
      logger.error(error)
    }
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken?,
             objectIDs: [ObjectID],
             positions: [Int],
             queryID: QueryID) {
    do {
      let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: Date(),
                                        queryID: queryID,
                                        objectIDsWithPositions: objectIDsWithPositions))
    } catch let error {
      logger.error(error)
    }
  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: Date(),
                                        objectIDs: objectIDs))
    } catch let error {
      logger.error(error)
    }

  }

  func click(eventName: EventName,
             indexName: IndexName,
             userToken: UserToken? = .none,
             filters: [String]) {
    do {
      eventProcessor.process(try .click(name: eventName,
                                        indexName: indexName,
                                        userToken: effectiveUserToken(withEventUserToken: userToken),
                                        timestamp: Date(),
                                        filters: filters))
    } catch let error {
      logger.error(error)
    }

  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  objectIDs: [ObjectID]) {
    do {
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: Date(),
                                             queryID: nil,
                                             objectIDs: objectIDs))
    } catch let error {
      logger.error(error)
    }
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken? = .none,
                  filters: [String]) {
    do {
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: Date(),
                                             queryID: nil,
                                             filters: filters))
    } catch let error {
      logger.error(error)
    }
  }

  func conversion(eventName: EventName,
                  indexName: IndexName,
                  userToken: UserToken?,
                  objectIDs: [ObjectID],
                  queryID: QueryID) {

    do {
      eventProcessor.process(try .conversion(name: eventName,
                                             indexName: indexName,
                                             userToken: effectiveUserToken(withEventUserToken: userToken),
                                             timestamp: Date(),
                                             queryID: queryID,
                                             objectIDs: objectIDs))
    } catch let error {
      logger.error(error)
    }

  }

}
