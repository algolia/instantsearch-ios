//
//  ArrayPackager+InsightsEvent.swift
//
//
//  Created by Vladislav Fitc on 19/10/2020.
//

import Compat
import Foundation

extension Packager where Item == InsightsEvent {
  init() {
    self.init(packageCapacity: Algolia.Insights.minBatchSize)
  }
}
