//
//  StatsPresneter.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias StatsPresenter<Output> = Presenter<SearchStats?, Output>

public extension DefaultPresenter {
  enum Stats {
    public static let present: StatsPresenter<String?> = { stats in
      let resultsString: String?
      switch (stats?.nbSortedHits, stats?.totalHitsCount) {
      case let (.some(nbSortedHits), .some(totalHitsCount)) where nbSortedHits != totalHitsCount:
        resultsString = "\(nbSortedHits) relevant results sorted out of \(totalHitsCount)"
      case let (_, .some(totalHitsCount)):
        resultsString = "\(totalHitsCount) results"
      default:
        resultsString = nil
      }
      let processingTimeString = (stats?.processingTimeMS).flatMap { "(\($0)ms)" }
      return [resultsString, processingTimeString].compactMap { $0 }.joined(separator: " ")
    }
  }
}
