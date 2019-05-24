//
//  LabelStatsController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

extension Optional where Wrapped == Bool {

  var falseOrNil: Bool {
    switch self {
    case .some(true):
      return false
    default:
      return true
    }
  }

}

public class LabelStatsController: StatsController {

  let label: UILabel

  public init (label: UILabel) {
    self.label = label
  }

  // TODO: add a Stat formatter for easier customisation

  public func renderWith<T>(statsMetadata: StatsMetadata, query: Query, filterState: FilterState, searchResults: SearchResults<T>) {
    let prefix = statsMetadata.areFacetsCountExhaustive.falseOrNil ? "" : "~"
    label.text = "\(prefix)\(statsMetadata.totalHitsCount) results"
  }

}
