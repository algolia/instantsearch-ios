//
//  Insights+SearchEventTracking.swift
//  InstantSearchInsights
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Foundation

/// Tracking events tighten to search
public extension Insights {
  /// Track a click related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.
  /// - parameter queryID: Algolia queryID
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func clickedAfterSearch(eventName: String,
                          indexName: String,
                          objectIDs: [String],
                          positions: [Int],
                          queryID: String,
                          timestamp: Date? = .none,
                          userToken: String? = .none) {
    eventTracker.click(eventName: eventName,
                       indexName: indexName,
                       userToken: userToken,
                       timestamp: timestamp,
                       objectIDs: objectIDs,
                       positions: positions,
                       queryID: queryID)
  }

  /// Track a click related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDsWithPositions: An array of related index objectID and position of the click in the list of Algolia search results. - Warning: Limited to 20 objects.
  /// - parameter queryID: Algolia queryID
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func clickedAfterSearch(eventName: String,
                          indexName: String,
                          objectIDsWithPositions: [(String, Int)],
                          queryID: String,
                          timestamp: Date? = .none,
                          userToken: String? = .none) {
    clickedAfterSearch(eventName: eventName,
                       indexName: indexName,
                       objectIDs: objectIDsWithPositions.map { $0.0 },
                       positions: objectIDsWithPositions.map { $0.1 },
                       queryID: queryID,
                       timestamp: timestamp,
                       userToken: userToken)
  }

  /// Track a click related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter position: Position of the click in the list of Algolia search results
  /// - parameter queryID: Algolia queryID
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func clickedAfterSearch(eventName: String,
                          indexName: String,
                          objectID: String,
                          position: Int,
                          queryID: String,
                          timestamp: Date? = .none,
                          userToken: String? = .none) {
    clickedAfterSearch(eventName: eventName,
                       indexName: indexName,
                       objectIDs: [objectID],
                       positions: [position],
                       queryID: queryID,
                       timestamp: timestamp,
                       userToken: userToken)
  }

  /// Track a conversion related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter queryID: Algolia queryID
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func convertedAfterSearch(eventName: String,
                            indexName: String,
                            objectIDs: [String],
                            queryID: String,
                            timestamp: Date? = .none,
                            userToken: String? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            objectIDs: objectIDs,
                            queryID: queryID)
  }

  /// Track a conversion related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter queryID: Algolia queryID
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func convertedAfterSearch(eventName: String,
                            indexName: String,
                            objectID: String,
                            queryID: String,
                            timestamp: Date? = .none,
                            userToken: String? = .none) {
    eventTracker.conversion(eventName: eventName,
                            indexName: indexName,
                            userToken: userToken,
                            timestamp: timestamp,
                            objectIDs: [objectID],
                            queryID: queryID)
  }
}
