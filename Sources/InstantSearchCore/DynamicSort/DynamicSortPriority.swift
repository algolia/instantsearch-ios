//
//  DynamicSortPriority.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

/**
  `DynamicSortPriority` represents the priority to apply to the search in the dynamically sorted index
 */
public enum DynamicSortPriority {
  /// Prioritize less more relevant results
  case relevancy

  /// Prioritize more less relevant results
  case hitsCount
}

extension DynamicSortPriority {

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
