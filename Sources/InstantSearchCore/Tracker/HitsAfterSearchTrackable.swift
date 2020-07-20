//
//  HitsAfterSearchTrackable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchInsights

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

extension Insights: HitsAfterSearchTrackable {

  func clickedAfterSearch(eventName: EventName, indexName: IndexName, objectIDsWithPositions: [(ObjectID, Int)], queryID: QueryID, userToken: UserToken?) {
    self.clickedAfterSearch(eventName: eventName.rawValue, indexName: indexName.rawValue, objectIDsWithPositions: objectIDsWithPositions.map { ($0.rawValue, $1) }, queryID: queryID.rawValue, userToken: userToken?.rawValue)
  }

  func convertedAfterSearch(eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], queryID: QueryID, userToken: UserToken?) {
    self.convertedAfterSearch(eventName: eventName.rawValue, indexName: indexName.rawValue, objectIDs: objectIDs.map(\.rawValue), queryID: queryID.rawValue, userToken: userToken?.rawValue)
  }

  func viewed(eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], userToken: UserToken?) {
    self.viewed(eventName: eventName.rawValue, indexName: indexName.rawValue, objectIDs: objectIDs.map(\.rawValue), userToken: userToken?.rawValue)
  }

}
