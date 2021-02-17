//
//  SmartSortPriority.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

/**
  `SmartSortPriority` represents the priority to apply to the search in the dynamically sorted index (virtual replica)
   It encapsulates `relevancyStrictness` query parameter by reducing its range to a binary state.
 */
public enum SmartSortPriority {
  /// Prioritize lesser more relevant results
  case relevancy

  /// Prioritize more less relevant results
  case hitsCount
}

extension SmartSortPriority {

  /// Relevancy strictness value to apply to the search
  public var relevancyStrictness: Int {
    switch self {
    case .hitsCount:
      return 0
    case .relevancy:
      return 100
    }
  }

  public init(relevancyStrictness: Int) {
    if relevancyStrictness > 0 {
      self = .relevancy
    } else {
      self = .hitsCount
    }
  }

}
