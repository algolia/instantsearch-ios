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

public class HitsTracker: InsightsTracker {

  public let eventName: EventName
  internal let searcher: TrackableSearcher
  internal let tracker: HitsAfterSearchTrackable
  internal var queryID: QueryID?

  public required convenience init(eventName: EventName,
                                   searcher: TrackableSearcher,
                                   insights: Insights) {
    self.init(eventName: eventName,
              searcher: searcher,
              tracker: insights)
  }

  init(eventName: EventName,
       searcher: TrackableSearcher,
       tracker: HitsAfterSearchTrackable) {
    self.eventName = eventName
    self.searcher = searcher
    self.tracker = tracker

    searcher.setClickAnalyticsOn(true)
    searcher.subscribeForQueryIDChange(self)
  }

  deinit {
    switch searcher {
    case .singleIndex(let searcher):
      searcher.onResults.cancelSubscription(for: self)
    case .multiIndex(let searcher, _):
      searcher.onResults.cancelSubscription(for: self)
    }
  }

}

// MARK: - Hits tracking methods

public extension HitsTracker {

  func trackClick<Record: Codable>(for hit: Hit<Record>,
                                   position: Int,
                                   eventName customEventName: EventName? = nil) {
    guard let queryID = queryID else { return }
    tracker.clickedAfterSearch(eventName: customEventName ?? self.eventName,
                               indexName: searcher.indexName,
                               objectIDsWithPositions: [(hit.objectID, position)],
                               queryID: queryID,
                               timestamp: .none,
                               userToken: .none)
  }

  func trackConvert<Record: Codable>(for hit: Hit<Record>,
                                     eventName customEventName: EventName? = nil) {
    guard let queryID = queryID else { return }
    tracker.convertedAfterSearch(eventName: customEventName ?? self.eventName,
                                 indexName: searcher.indexName,
                                 objectIDs: [hit.objectID],
                                 queryID: queryID,
                                 timestamp: .none,
                                 userToken: .none)
  }

  func trackView<Record: Codable>(for hit: Hit<Record>,
                                  eventName customEventName: EventName? = nil) {
    tracker.viewed(eventName: customEventName ?? self.eventName,
                   indexName: searcher.indexName,
                   objectIDs: [hit.objectID],
                   timestamp: .none,
                   userToken: .none)
  }

}
