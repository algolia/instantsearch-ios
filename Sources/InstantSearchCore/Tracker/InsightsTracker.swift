//
//  InsightsTracker.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
#if !InstantSearchCocoaPods
  import InstantSearchInsights
#endif

public protocol InsightsTracker: AnyObject {
  init(eventName: String, searcher: TrackableSearcher, insights: Insights)
}

public extension InsightsTracker {
  init(eventName: String,
       searcher: HitsSearcher,
       userToken: UserToken? = .none) {
    // In v9, appID is internal on SearchClient - users should register Insights explicitly or use the other init
    guard let insights = Insights.shared else {
      fatalError("Insights must be registered before creating InsightsTracker. Call Insights.register(appId:apiKey:) first.")
    }
    self.init(eventName: eventName,
              searcher: .singleIndex(searcher),
              insights: insights)
  }

  init(eventName: String,
       searcher: HitsSearcher,
       insights: Insights) {
    self.init(eventName: eventName,
              searcher: .singleIndex(searcher),
              insights: insights)
  }

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
  init(eventName: String,
       searcher: MultiIndexSearcher,
       pointer: Int,
       userToken: UserToken? = .none) {
    guard let insights = Insights.shared else {
      fatalError("Insights must be registered before creating InsightsTracker. Call Insights.register(appId:apiKey:) first.")
    }
    self.init(eventName: eventName,
              searcher: .multiIndex(searcher, pointer: pointer),
              insights: insights)
  }

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
  init(eventName: String,
       searcher: MultiIndexSearcher,
       pointer: Int,
       insights: Insights) {
    self.init(eventName: eventName,
              searcher: .multiIndex(searcher, pointer: pointer),
              insights: insights)
  }
}
