//
//  TrackableSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

protocol QueryIDContainer: AnyObject {
  var queryID: QueryID? { get set }
}

extension HitsTracker: QueryIDContainer {}

public enum TrackableSearcher {
  case singleIndex(HitsSearcher)

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
  case multiIndex(MultiIndexSearcher, pointer: Int)

  var indexName: IndexName {
    switch self {
    case let .singleIndex(searcher):
      return searcher.request.indexName

    case let .multiIndex(searcher, pointer: index):
      return searcher.indexQueryStates[index].indexName
    }
  }

  func setClickAnalyticsOn(_ on: Bool) {
    switch self {
    case let .singleIndex(searcher):
      return searcher.request.query.clickAnalytics = on

    case let .multiIndex(searcher, pointer: index):
      return searcher.indexQueryStates[index].query.clickAnalytics = on
    }
  }

  func subscribeForQueryIDChange<S: QueryIDContainer>(_ subscriber: S) {
    switch self {
    case let .singleIndex(searcher):
      searcher.onResults.subscribe(with: subscriber) { subscriber, results in
        subscriber.queryID = results.queryID
      }
    case let .multiIndex(searcher, pointer: index):
      searcher.onResults.subscribe(with: subscriber) { subscriber, results in
        subscriber.queryID = results.results[index].queryID
      }
    }
  }
}
