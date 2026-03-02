//
//  HitsAfterSearchTrackable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
#if !InstantSearchCocoaPods
  import InstantSearchInsights
#endif
protocol HitsAfterSearchTrackable {
  func clickedAfterSearch(eventName: String,
                          indexName: String,
                          objectIDsWithPositions: [(String, Int)],
                          queryID: String,
                          timestamp: Date?,
                          userToken: String?)

  func convertedAfterSearch(eventName: String,
                            indexName: String,
                            objectIDs: [String],
                            queryID: String,
                            timestamp: Date?,
                            userToken: String?)

  func viewed(eventName: String,
              indexName: String,
              objectIDs: [String],
              timestamp: Date?,
              userToken: String?)
}

extension Insights: HitsAfterSearchTrackable {}
