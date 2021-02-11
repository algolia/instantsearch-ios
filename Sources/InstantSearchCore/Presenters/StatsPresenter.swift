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
      case (.some(let nbSortedHits), .some(let totalHitsCount)) where nbSortedHits != totalHitsCount:
        resultsString = "\(nbSortedHits) relevant results sorted out of \(totalHitsCount)"
      case (_, .some(let totalHitsCount)):
        resultsString = "\(totalHitsCount) results"
      default:
        resultsString = nil
      }
      let processingTimeString = (stats?.processingTimeMS).flatMap { "(\($0)ms)" }
      return [resultsString, processingTimeString].compactMap { $0 }.joined(separator: " ")
    }

  }
}
