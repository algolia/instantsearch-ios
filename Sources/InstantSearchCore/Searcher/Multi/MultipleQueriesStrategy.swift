//
//  MultipleQueriesStrategy.swift
//  InstantSearchCore
//

import Foundation
import Search

public enum MultipleQueriesStrategy: String, Codable, CaseIterable {
  case none
  case stopIfEnoughMatches

  var searchStrategy: SearchStrategy {
    switch self {
    case .none:
      return .none
    case .stopIfEnoughMatches:
      return .stopIfEnoughMatches
    }
  }
}

