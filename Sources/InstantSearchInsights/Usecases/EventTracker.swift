//
//  EventTracker.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides convenient functions for tracking events which can be used for search personalization.
///

class EventTracker: NSObject, AnalyticsUsecase, EventTrackable {
    
    var eventProcessor: EventProcessable
    var logger: Logger
    var userToken: String?
    
    init(eventProcessor: EventProcessable,
         logger: Logger,
         userToken: String? = .none) {
        self.eventProcessor = eventProcessor
        self.logger = logger
        self.userToken = userToken
    }
    
    func view(eventName: String,
              indexName: String,
              userToken: String? = .none,
              objectIDs: [String]) {
        do {
            let event = try ViewEvent(name: eventName,
                                      indexName: indexName,
                                      userToken: effectiveUserToken(withEventUserToken: userToken),
                                      timestamp: Date().millisecondsSince1970,
                                      queryID: .none,
                                      objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    func view(eventName: String,
              indexName: String,
              userToken: String? = .none,
              filters: [String]) {
        do {
            let event = try ViewEvent(name: eventName,
                                      indexName: indexName,
                                      userToken: effectiveUserToken(withEventUserToken: userToken),
                                      timestamp: Date().millisecondsSince1970,
                                      queryID: .none,
                                      objectIDsOrFilters: .filters(filters))
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               objectIDs: [String],
               positions: [Int],
               queryID: String) {
        do {
            guard objectIDs.count == positions.count else {
                throw EventConstructionError.objectsAndPositionsCountMismatch(objectIDsCount: objectIDs.count, positionsCount: positions.count)
            }
            let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
            let event = try ClickEvent(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: Date().millisecondsSince1970,
                                       queryID: queryID,
                                       objectIDsWithPositions: objectIDsWithPositions)
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    func click(eventName: String,
               indexName: String,
               userToken: String? = .none,
               objectIDs: [String]) {
        do {
            let event = try ClickEvent(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: Date().millisecondsSince1970,
                                       objectIDsOrFilters: .objectIDs(objectIDs),
                                       positions: .none)
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
        
    }
    
    func click(eventName: String,
               indexName: String,
               userToken: String? = .none,
               filters: [String]) {
        do {
            let event = try ClickEvent(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: Date().millisecondsSince1970,
                                       objectIDsOrFilters: .filters(filters),
                                       positions: .none)
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
        
    }
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String? = .none,
                    objectIDs: [String]) {
        do {
            let event = try ConversionEvent(name: eventName,
                                            indexName: indexName,
                                            userToken: effectiveUserToken(withEventUserToken: userToken),
                                            timestamp: Date().millisecondsSince1970,
                                            queryID: .none,
                                            objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String? = .none,
                    filters: [String]) {
        do {
            let event = try ConversionEvent(name: eventName,
                                            indexName: indexName,
                                            userToken: effectiveUserToken(withEventUserToken: userToken),
                                            timestamp: Date().millisecondsSince1970,
                                            queryID: .none,
                                            objectIDsOrFilters: .filters(filters))
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    objectIDs: [String],
                    queryID: String) {
        
        do {
            let event = try ConversionEvent(name: eventName,
                                            indexName: indexName,
                                            userToken: effectiveUserToken(withEventUserToken: userToken),
                                            timestamp: Date().millisecondsSince1970,
                                            queryID: queryID,
                                            objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
        
    }

}
