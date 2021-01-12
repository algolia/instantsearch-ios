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

  func clickedAfterSearch(eventName: EventName,
                          indexName: IndexName,
                          objectIDsWithPositions: [(ObjectID, Int)],
                          queryID: QueryID,
                          userToken: UserToken?)

  func convertedAfterSearch(eventName: EventName,
                            indexName: IndexName,
                            objectIDs: [ObjectID],
                            queryID: QueryID,
                            userToken: UserToken?)

  func viewed(eventName: EventName,
              indexName: IndexName,
              objectIDs: [ObjectID],
              userToken: UserToken?)

}

extension Insights: HitsAfterSearchTrackable {}
