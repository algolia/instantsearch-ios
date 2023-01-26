//
//  MultiSearchError.swift
//
//
//  Created by Vladislav Fitc on 02/11/2022.
//

import Foundation

public enum MultiSearchError: LocalizedError {
  case resultsRangeMismatch(Range<Int>, Range<Int>)
  case serviceError(Error)

  var localizedDescription: String {
    switch self {
    case let .serviceError(error):
      return "Search service error: \(error.localizedDescription)"
    case let .resultsRangeMismatch(subRange, range):
      return "The calculated results subrange \(subRange) can't be extracted from the results list with bounds \(range)"
    }
  }
}
