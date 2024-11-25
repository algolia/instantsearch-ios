//
//  Package+InsightsEvent.swift
//
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import Insights

extension Package where Item == EventsItems {
  init() {
    self.init(capacity: Algolia.Insights.minBatchSize)
  }

  init(event: Item) {
    self.init(item: event, capacity: Algolia.Insights.minBatchSize)
  }

  init(events: [Item]) throws {
    try self.init(items: events, capacity: Algolia.Insights.minBatchSize)
  }
}
