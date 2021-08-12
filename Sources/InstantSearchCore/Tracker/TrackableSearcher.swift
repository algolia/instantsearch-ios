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
  
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  case multiIndex(MultiIndexSearcher, pointer: Int)

  var indexName: IndexName {
    switch self {
    case .singleIndex(let searcher):
      return searcher.request.indexName

    case .multiIndex(let searcher, pointer: let index):
      return searcher.indexQueryStates[index].indexName
    }
  }

  func setClickAnalyticsOn(_ on: Bool) {
    switch self {
    case .singleIndex(let searcher):
      return searcher.request.query.clickAnalytics = on

    case .multiIndex(let searcher, pointer: let index):
      return searcher.indexQueryStates[index].query.clickAnalytics = on
    }
  }

  func subscribeForQueryIDChange<S: QueryIDContainer>(_ subscriber: S) {
    switch self {
    case .singleIndex(let searcher):
      searcher.onResults.subscribe(with: subscriber) { (subscriber, results) in
        subscriber.queryID = results.queryID
      }
    case .multiIndex(let searcher, pointer: let index):
      searcher.onResults.subscribe(with: subscriber) { (subscriber, results) in
        subscriber.queryID = results.results[index].queryID
      }
    }

  }

}
