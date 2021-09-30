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

  public let eventName: EventName
  internal let searcher: TrackableSearcher
  internal let tracker: FilterTrackable

  public required convenience init(eventName: EventName,
                                   searcher: TrackableSearcher,
                                   insights: Insights) {
    self.init(eventName: eventName,
              searcher: searcher,
              tracker: insights)
  }

  init(eventName: EventName,
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
                                 eventName customEventName: EventName? = nil) {
    guard let sqlForm = (filter as? SQLSyntaxConvertible)?.sqlForm else { return }
    tracker.clicked(eventName: customEventName ?? eventName,
                    indexName: searcher.indexName,
                    filters: [sqlForm],
                    timestamp: .none,
                    userToken: .none)
  }

  func trackView<F: FilterType>(for filter: F,
                                eventName customEventName: EventName? = nil) {
    guard let sqlForm = (filter as? SQLSyntaxConvertible)?.sqlForm else { return }
    tracker.viewed(eventName: customEventName ?? eventName,
                   indexName: searcher.indexName,
                   filters: [sqlForm],
                   timestamp: .none,
                   userToken: .none)
  }

  func trackConversion<F: FilterType>(for filter: F,
                                      eventName customEventName: EventName? = nil) {
    guard let sqlForm = (filter as? SQLSyntaxConvertible)?.sqlForm else { return }
    tracker.converted(eventName: customEventName ?? eventName,
                      indexName: searcher.indexName,
                      filters: [sqlForm],
                      timestamp: .none,
                      userToken: .none)
  }

}

// MARK: - Facet tracking methods

public extension FilterTracker {

  private func filter(for facet: Facet, with attribute: Attribute) -> Filter.Facet {
    return Filter.Facet(attribute: attribute, stringValue: facet.value)
  }

  func trackClick(for facet: Facet,
                  attribute: Attribute,
                  eventName customEventName: EventName? = nil) {
    trackClick(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }

  func trackView(for facet: Facet,
                 attribute: Attribute,
                 eventName customEventName: EventName? = nil) {
    trackView(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }

  func trackConversion(for facet: Facet,
                       attribute: Attribute,
                       eventName customEventName: EventName? = nil) {
    trackConversion(for: filter(for: facet, with: attribute), eventName: customEventName ?? eventName)
  }

}
