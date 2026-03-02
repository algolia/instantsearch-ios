//
//  Insights+EventTracking.swift
//  InstantSearchInsights
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Foundation

/// Tracking events non-tighten to search
public extension Insights {
  /// Track a view
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func viewed(eventName: String,
              indexName: String,
              objectIDs: [String],
              timestamp: Date? = .none,
              userToken: String? = .none) {
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

  func viewed(eventName: String,
              indexName: String,
              objectID: String,
              timestamp: Date? = nil,
              userToken: String? = .none) {
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

  func viewed(eventName: String,
              indexName: String,
              filters: [String],
              timestamp: Date? = .none,
              userToken: String? = .none) {
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

  func clicked(eventName: String,
               indexName: String,
               objectIDs: [String],
               timestamp: Date? = .none,
               userToken: String? = .none) {
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

  func clicked(eventName: String,
               indexName: String,
               objectID: String,
               timestamp: Date? = .none,
               userToken: String? = .none) {
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

  func clicked(eventName: String,
               indexName: String,
               filters: [String],
               timestamp: Date? = .none,
               userToken: String? = .none) {
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

  func converted(eventName: String,
                 indexName: String,
                 objectIDs: [String],
                 timestamp: Date? = .none,
                 userToken: String? = .none) {
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

  func converted(eventName: String,
                 indexName: String,
                 objectID: String,
                 timestamp: Date? = .none,
                 userToken: String? = .none) {
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

  func converted(eventName: String,
                 indexName: String,
                 filters: [String],
                 timestamp: Date? = .none,
                 userToken: String? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            filters: filters)
  }
}
