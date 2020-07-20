//
//  TestHitsTracker.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

class TestHitsTracker: HitsAfterSearchTrackable {

  var didClick: (((eventName: EventName, indexName: IndexName, objectIDsWithPositions: [(ObjectID, Int)], queryID: QueryID, userToken: UserToken?)) -> Void)?
  var didConvert: (((eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], queryID: QueryID, userToken: UserToken?)) -> Void)?
  var didView: (((eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], userToken: UserToken?)) -> Void)?

  func clickedAfterSearch(eventName: EventName, indexName: IndexName, objectIDsWithPositions: [(ObjectID, Int)], queryID: QueryID, userToken: UserToken?) {
      didClick?((eventName, indexName, objectIDsWithPositions, queryID, userToken))
  }

  func convertedAfterSearch(eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], queryID: QueryID, userToken: UserToken?) {
    didConvert?((eventName, indexName, objectIDs, queryID, userToken))
  }

  func viewed(eventName: EventName, indexName: IndexName, objectIDs: [ObjectID], userToken: UserToken?) {
    didView?((eventName, indexName, objectIDs, userToken))
  }

}
