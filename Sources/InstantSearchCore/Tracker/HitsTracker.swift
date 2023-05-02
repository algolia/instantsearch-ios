//
//  HitsInteractor+Tracker.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 18/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
#if !InstantSearchCocoaPods
import InstantSearchInsights
#endif

/// The HitsTracker class allows to track user interactions with search results using Algolia Insights.
/// It implements the InsightsTracker protocol and provides methods for tracking clicks, conversions, and views for search results.
public class HitsTracker: InsightsTracker {

  /// The name of the event to track.
  public let eventName: EventName

  public var isEnabled: Bool

  /// A `TrackableSearcher` object that provides search results to be tracked.
  internal let searcher: TrackableSearcher

  /// A `HitsAfterSearchTrackable` object that tracks search result interactions.
  internal let tracker: HitsAfterSearchTrackable

  /// An optional identifier for the search query.
  internal var queryID: QueryID?

  /// Initializes a new instance of the `HitsTracker` class with the specified event name, `TrackableSearcher`, and `Insights` object.
  ///
  /// - Parameters:
  ///   - eventName: The name of the event to track.
  ///   - searcher: A `TrackableSearcher` object that provides search results to be tracked.
  ///   - insights: An `Insights` object.
  public required convenience init(eventName: EventName,
                                   searcher: TrackableSearcher,
                                   insights: Insights) {
    self.init(eventName: eventName,
              searcher: searcher,
              tracker: insights)
  }

  /// Initializes a new instance of the `HitsTracker` class with the specified event name, `TrackableSearcher`, and `HitsAfterSearchTrackable` object.
  ///
  /// - Parameters:
  ///   - eventName: The name of the event to track.
  ///   - searcher: A `TrackableSearcher` object that provides search results to be tracked.
  ///   - tracker: A `HitsAfterSearchTrackable` object that tracks search result interactions.
  init(eventName: EventName,
       searcher: TrackableSearcher,
       tracker: HitsAfterSearchTrackable) {
    self.eventName = eventName
    self.searcher = searcher
    self.tracker = tracker
    self.isEnabled = true
    searcher.setClickAnalyticsOn(true)
    searcher.subscribeForQueryIDChange(self)
  }

  deinit {
    switch searcher {
    case let .singleIndex(searcher):
      searcher.onResults.cancelSubscription(for: self)
    case let .multiIndex(searcher, _):
      searcher.onResults.cancelSubscription(for: self)
    }
  }
}

// MARK: - Hits tracking methods

public extension HitsTracker {

  /// Tracks a click event for the specified search result at the specified position.
  ///
  /// - Parameters:
  ///   - hit: The search result for which to track the click event.
  ///   - position: The position of the search result in the search results list.
  ///   - eventName: An optional custom event name.
  func trackClick<Record: Codable>(for hit: Hit<Record>,
                                   position: Int,
                                   eventName: EventName? = nil) {
    trackClick(for: [hit],
               positions: [position],
               eventName: eventName)
  }

  /// Tracks a click event for the specified search results at the specified positions.
  ///
  /// - Parameters:
  ///   - hits: The search results for which to track the click event.
  ///   - positions: The positions of the search results in the search results list.
  ///   - eventName: An optional custom event name.
  func trackClick<Record: Codable>(for hits: [Hit<Record>],
                                   positions: [Int],
                                   eventName: EventName? = nil) {
    guard isEnabled else { return }
    guard let queryID = queryID else { return }
    tracker.clickedAfterSearch(eventName: eventName ?? self.eventName,
                               indexName: searcher.indexName,
                               objectIDsWithPositions: Array(zip(hits.map(\.objectID), positions)),
                               queryID: queryID,
                               timestamp: .none,
                               userToken: .none)
  }

  /// Tracks a conversion event for the specified search result.
  ///
  /// - Parameters:
  ///   - hit: The search result for which to track the conversion event.
  ///   - eventName: An optional custom event name.
  func trackConvert<Record: Codable>(for hit: Hit<Record>,
                                     eventName: EventName? = nil) {
    trackConvert(for: [hit],
                 eventName: eventName)
  }

  /// Tracks a conversion event for the specified search results.
  ///
  /// - Parameters:
  ///   - hits: The search results for which to track the conversion event.
  ///   - eventName: An optional custom event name.
  func trackConvert<Record: Codable>(for hits: [Hit<Record>],
                                     eventName: EventName? = nil) {
    guard isEnabled else { return }
    guard let queryID = queryID else { return }
    tracker.convertedAfterSearch(eventName: eventName ?? self.eventName,
                                 indexName: searcher.indexName,
                                 objectIDs: hits.map(\.objectID),
                                 queryID: queryID,
                                 timestamp: .none,
                                 userToken: .none)
  }

  /// Tracks a view event for the specified search result.
  ///
  /// - Parameters:
  ///   - hit: The search result for which to track the view event.
  ///   - eventName: An optional custom event name.
  func trackView<Record: Codable>(for hit: Hit<Record>,
                                  eventName: EventName? = nil) {
    trackView(for: [hit],
              eventName: eventName)
  }

  /// Tracks a view event for the specified search results.
  ///
  /// - Parameters:
  ///   - hits: The search results for which to track the view event.
  ///   - eventName: An optional custom event name.
  func trackView<Record: Codable>(for hits: [Hit<Record>],
                                  eventName: EventName? = nil) {
    guard isEnabled else { return }
    tracker.viewed(eventName: eventName ?? self.eventName,
                   indexName: searcher.indexName,
                   objectIDs: hits.map(\.objectID),
                   timestamp: .none,
                   userToken: .none)
  }
}
