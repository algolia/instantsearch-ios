//
//  ArrayPackager+InsightsEvent.swift
//
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Foundation
import Insights

extension Packager where Item == EventsItems {
  init() {
    self.init(packageCapacity: Algolia.Insights.minBatchSize)
  }
}
