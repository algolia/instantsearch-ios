//
//  FilterTracker.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 18/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
#if !InstantSearchCocoaPods
  import InstantSearchInsights
#endif

public class FilterTracker: InsightsTracker {
  public let eventName: String
  internal let searcher: TrackableSearcher
  internal let tracker: FilterTrackable

  public required convenience init(eventName: String,
                                   searcher: TrackableSearcher,
                                   insights: Insights) {
    self.init(eventName: eventName,
              searcher: searcher,
              tracker: insights)
  }

  init(eventName: String,
       searcher: TrackableSearcher,
       tracker: FilterTrackable) {
    self.eventName = eventName
    self.searcher = searcher
    self.tracker = tracker
  }
}

// MARK: - Filter tracking methods

public extension FilterTracker {
  func trackClick<F: FilterType>(for filter: F,
                                 eventName customEventName: String? = nil) {
    guard let legacy = FilterConverter().legacy(filter) else { return }
    let filters = legacy.units.flatMap(\.rawFilters)
    tracker.clicked(eventName: customEventName ?? eventName,
                    indexName: searcher.indexName,
                    filters: filters,
                    timestamp: .none,
                    userToken: .none)
  }

  func trackView<F: FilterType>(for filter: F,
                                eventName customEventName: String? = nil) {
    guard let legacy = FilterConverter().legacy(filter) else { return }
    let filters = legacy.units.flatMap(\.rawFilters)
    tracker.viewed(eventName: customEventName ?? eventName,
                   indexName: searcher.indexName,
                   filters: filters,
                   timestamp: .none,
                   userToken: .none)
  }

  func trackConversion<F: FilterType>(for filter: F,
                                      eventName customEventName: String? = nil) {
    guard let legacy = FilterConverter().legacy(filter) else { return }
    let filters = legacy.units.flatMap(\.rawFilters)
    tracker.converted(eventName: customEventName ?? eventName,
                      indexName: searcher.indexName,
                      filters: filters,
                      timestamp: .none,
                      userToken: .none)
  }
}

// MARK: - Facet tracking methods

public extension FilterTracker {
  private func filter(for facet: FacetHits, with attribute: String) -> Filter.Facet {
    return Filter.Facet(attribute: attribute, stringValue: facet.value)
  }

  func trackClick(for facet: FacetHits,
                  attribute: String,
                  eventName customEventName: String? = nil) {
    trackClick(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }

  func trackView(for facet: FacetHits,
                 attribute: String,
                 eventName customEventName: String? = nil) {
    trackView(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }

  func trackConversion(for facet: FacetHits,
                       attribute: String,
                       eventName customEventName: String? = nil) {
    trackConversion(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }
}
