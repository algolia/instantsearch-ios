//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

/// Provides convenient functions for tracking events which can be used for search personalization.
///

class EventTracker: NSObject, AnalyticsUsecase, EventTrackable {
    
    var eventProcessor: EventProcessable
    var logger: Logger
    var userToken: UserToken?
    
    init(eventProcessor: EventProcessable,
         logger: Logger,
         userToken: UserToken? = .none) {
        self.eventProcessor = eventProcessor
        self.logger = logger
        self.userToken = userToken
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
            logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
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
          logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
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
            logger.debug(message: error.localizedDescription)
        }
        
    }

}
