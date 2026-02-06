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
// swiftlint:disable function_parameter_count

protocol HitsAfterSearchTrackable {
  func clickedAfterSearch(eventName: String,
                          indexName: String,
                          objectIDsWithPositions: [(String, Int)],
                          queryID: String,
                          timestamp: Date?,
                          userToken: UserToken?)

  func convertedAfterSearch(eventName: String,
                            indexName: String,
                            objectIDs: [String],
                            queryID: String,
                            timestamp: Date?,
                            userToken: UserToken?)

  func viewed(eventName: String,
              indexName: String,
              objectIDs: [String],
              timestamp: Date?,
              userToken: UserToken?)
}

extension Insights: HitsAfterSearchTrackable {}
// swiftlint:enable function_parameter_count
