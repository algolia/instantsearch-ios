//
//  Insights+EventTracking.swift
//  InstantSearchInsights
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Foundation
import AlgoliaSearchClient

/// Tracking events non-tighten to search
extension Insights {

  /// Track a view
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func viewed(eventName: EventName,
                     indexName: IndexName,
                     objectIDs: [ObjectID],
                     timestamp: Date? = .none,
                     userToken: UserToken? = .none) {
    eventTracker.view(eventName: eventName,
                      indexName: indexName,
                      userToken: userToken,
                      timestamp: timestamp,
                      objectIDs: objectIDs)
  }

  /// Track a view
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func viewed(eventName: EventName,
                     indexName: IndexName,
                     objectID: ObjectID,
                     timestamp: Date? = nil,
                     userToken: UserToken? = .none) {
    eventTracker.view(eventName: eventName,
                      indexName: indexName,
                      userToken: userToken,
                      timestamp: timestamp,
                      objectIDs: [objectID])
  }

  /// Track a view
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter filters: An array of filters. Limited to 10 filters.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func viewed(eventName: EventName,
                     indexName: IndexName,
                     filters: [String],
                     timestamp: Date? = .none,
                     userToken: UserToken? = .none) {
    eventTracker.view(eventName: eventName,
                      indexName: indexName,
                      userToken: userToken,
                      timestamp: timestamp,
                      filters: filters)
  }

  /// Track a click
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func clicked(eventName: EventName,
                      indexName: IndexName,
                      objectIDs: [ObjectID],
                      timestamp: Date? = .none,
                      userToken: UserToken? = .none) {
    eventTracker.click(eventName: eventName,
                       indexName: indexName,
                       userToken: userToken,
                       timestamp: timestamp,
                       objectIDs: objectIDs)
  }

  /// Track a click
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func clicked(eventName: EventName,
                      indexName: IndexName,
                      objectID: ObjectID,
                      timestamp: Date? = .none,
                      userToken: UserToken? = .none) {
    eventTracker.click(eventName: eventName,
                       indexName: indexName,
                       userToken: userToken,
                       timestamp: timestamp,
                       objectIDs: [objectID])
  }

  /// Track a click
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter filters: An array of filters. Limited to 10 filters.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func clicked(eventName: EventName,
                      indexName: IndexName,
                      filters: [String],
                      timestamp: Date? = .none,
                      userToken: UserToken? = .none) {
    eventTracker.click(eventName: eventName,
                       indexName: indexName,
                       userToken: userToken,
                       timestamp: timestamp,
                       filters: filters)
  }

  /// Track a conversion
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func converted(eventName: EventName,
                        indexName: IndexName,
                        objectIDs: [ObjectID],
                        timestamp: Date? = .none,
                        userToken: UserToken? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            objectIDs: objectIDs)
  }

  /// Track a conversion
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func converted(eventName: EventName,
                        indexName: IndexName,
                        objectID: ObjectID,
                        timestamp: Date? = .none,
                        userToken: UserToken? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            objectIDs: [objectID])
  }

  /// Track a conversion
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter filters: An array of filters. Limited to 10 filters.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  public func converted(eventName: EventName,
                        indexName: IndexName,
                        filters: [String],
                        timestamp: Date? = .none,
                        userToken: UserToken? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            filters: filters)
  }

}
