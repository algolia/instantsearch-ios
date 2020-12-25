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

public protocol InsightsTracker: class {

  init(eventName: EventName, searcher: TrackableSearcher, insights: Insights)

}

extension InsightsTracker {

  public init(eventName: EventName,
              searcher: SingleIndexSearcher,
              userToken: UserToken? = .none) {
    let credentials: AlgoliaSearchClient.Credentials = searcher.client
    let insights = Insights.register(appId: credentials.applicationID, apiKey: credentials.apiKey, userToken: userToken)
    self.init(eventName: eventName,
              searcher: .singleIndex(searcher),
              insights: insights)
  }

  public init(eventName: EventName,
              searcher: SingleIndexSearcher,
              insights: Insights) {
    self.init(eventName: eventName,
              searcher: .singleIndex(searcher),
              insights: insights)
  }

  public init(eventName: EventName,
              searcher: MultiIndexSearcher,
              pointer: Int,
              userToken: UserToken? = .none) {
    let credentials: AlgoliaSearchClient.Credentials = searcher.client
    let insights = Insights.register(appId: credentials.applicationID, apiKey: credentials.apiKey, userToken: userToken)
    self.init(eventName: eventName,
              searcher: .multiIndex(searcher, pointer: pointer),
              insights: insights)
  }

  public init(eventName: EventName,
              searcher: MultiIndexSearcher,
              pointer: Int,
              insights: Insights) {
    self.init(eventName: eventName,
              searcher: .multiIndex(searcher, pointer: pointer),
              insights: insights)
  }

}
