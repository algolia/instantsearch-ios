//
//  Insights+CommerceEventTracking.swift
//  InstantSearchInsights
//

import AlgoliaInsights
import Foundation

/// Tracking commerce events (purchase and add-to-cart)
public extension Insights {
  // MARK: - Purchase events

  /// Track a purchase not related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter objectData: Extra information about the purchased items (price, quantity, discount)
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func purchased(eventName: String,
                 indexName: String,
                 objectIDs: [String],
                 objectData: [ObjectData]? = nil,
                 currency: String? = nil,
                 value: InsightsValue? = nil,
                 timestamp: Date? = .none,
                 userToken: String? = .none) {
    eventTracker.purchase(eventName: eventName,
                          indexName: indexName,
                          userToken: userToken,
                          timestamp: timestamp,
                          objectIDs: objectIDs,
                          objectData: objectData,
                          currency: currency,
                          value: value)
  }

  /// Track a purchase not related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter objectData: Extra information about the purchased item (price, quantity, discount)
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func purchased(eventName: String,
                 indexName: String,
                 objectID: String,
                 objectData: ObjectData? = nil,
                 currency: String? = nil,
                 value: InsightsValue? = nil,
                 timestamp: Date? = .none,
                 userToken: String? = .none) {
    purchased(eventName: eventName,
              indexName: indexName,
              objectIDs: [objectID],
              objectData: objectData.map { [$0] },
              currency: currency,
              value: value,
              timestamp: timestamp,
              userToken: userToken)
  }

  /// Track a purchase related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter objectData: Extra information about the purchased items (price, quantity, discount, queryID)
  /// - parameter queryID: Algolia queryID
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func purchasedAfterSearch(eventName: String,
                            indexName: String,
                            objectIDs: [String],
                            objectData: [ObjectDataAfterSearch],
                            queryID: String,
                            currency: String? = nil,
                            value: InsightsValue? = nil,
                            timestamp: Date? = .none,
                            userToken: String? = .none) {
    eventTracker.purchase(eventName: eventName,
                          indexName: indexName,
                          userToken: userToken,
                          timestamp: timestamp,
                          objectIDs: objectIDs,
                          objectDataAfterSearch: objectData,
                          queryID: queryID,
                          currency: currency,
                          value: value)
  }

  /// Track a purchase related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter objectData: Extra information about the purchased item (price, quantity, discount, queryID)
  /// - parameter queryID: Algolia queryID
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func purchasedAfterSearch(eventName: String,
                            indexName: String,
                            objectID: String,
                            objectData: ObjectDataAfterSearch,
                            queryID: String,
                            currency: String? = nil,
                            value: InsightsValue? = nil,
                            timestamp: Date? = .none,
                            userToken: String? = .none) {
    purchasedAfterSearch(eventName: eventName,
                         indexName: indexName,
                         objectIDs: [objectID],
                         objectData: [objectData],
                         queryID: queryID,
                         currency: currency,
                         value: value,
                         timestamp: timestamp,
                         userToken: userToken)
  }

  // MARK: - Add-to-cart events

  /// Track an add-to-cart event not related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter objectData: Extra information about the items added to cart (price, quantity, discount)
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func addedToCart(eventName: String,
                   indexName: String,
                   objectIDs: [String],
                   objectData: [ObjectData]? = nil,
                   currency: String? = nil,
                   value: InsightsValue? = nil,
                   timestamp: Date? = .none,
                   userToken: String? = .none) {
    eventTracker.addToCart(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           timestamp: timestamp,
                           objectIDs: objectIDs,
                           objectData: objectData,
                           currency: currency,
                           value: value)
  }

  /// Track an add-to-cart event not related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter objectData: Extra information about the item added to cart (price, quantity, discount)
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func addedToCart(eventName: String,
                   indexName: String,
                   objectID: String,
                   objectData: ObjectData? = nil,
                   currency: String? = nil,
                   value: InsightsValue? = nil,
                   timestamp: Date? = .none,
                   userToken: String? = .none) {
    addedToCart(eventName: eventName,
               indexName: indexName,
               objectIDs: [objectID],
               objectData: objectData.map { [$0] },
               currency: currency,
               value: value,
               timestamp: timestamp,
               userToken: userToken)
  }

  /// Track an add-to-cart event related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
  /// - parameter objectData: Extra information about the items added to cart (price, quantity, discount, queryID)
  /// - parameter queryID: Algolia queryID
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func addedToCartAfterSearch(eventName: String,
                              indexName: String,
                              objectIDs: [String],
                              objectData: [ObjectDataAfterSearch]? = nil,
                              queryID: String,
                              currency: String? = nil,
                              value: InsightsValue? = nil,
                              timestamp: Date? = .none,
                              userToken: String? = .none) {
    eventTracker.addToCart(eventName: eventName,
                           indexName: indexName,
                           userToken: userToken,
                           timestamp: timestamp,
                           objectIDs: objectIDs,
                           objectDataAfterSearch: objectData,
                           queryID: queryID,
                           currency: currency,
                           value: value)
  }

  /// Track an add-to-cart event related to search
  /// - parameter eventName: A user-defined string used to categorize events
  /// - parameter indexName: Name of the targeted index
  /// - parameter objectID: Index objectID
  /// - parameter objectData: Extra information about the item added to cart (price, quantity, discount, queryID)
  /// - parameter queryID: Algolia queryID
  /// - parameter currency: Three-letter ISO 4217 currency code
  /// - parameter value: Total monetary value of the event
  /// - parameter timestamp: Event timestamp
  /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.

  func addedToCartAfterSearch(eventName: String,
                              indexName: String,
                              objectID: String,
                              objectData: ObjectDataAfterSearch? = nil,
                              queryID: String,
                              currency: String? = nil,
                              value: InsightsValue? = nil,
                              timestamp: Date? = .none,
                              userToken: String? = .none) {
    addedToCartAfterSearch(eventName: eventName,
                           indexName: indexName,
                           objectIDs: [objectID],
                           objectData: objectData.map { [$0] },
                           queryID: queryID,
                           currency: currency,
                           value: value,
                           timestamp: timestamp,
                           userToken: userToken)
  }
}
