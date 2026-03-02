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
  var didClick: (((eventName: String, indexName: String, objectIDsWithPositions: [(String, Int)], queryID: String, timestamp: Date?, userToken: String?)) -> Void)?
  var didConvert: (((eventName: String, indexName: String, objectIDs: [String], queryID: String, timestamp: Date?, userToken: String?)) -> Void)?
  var didView: (((eventName: String, indexName: String, objectIDs: [String], timestamp: Date?, userToken: String?)) -> Void)?

  func clickedAfterSearch(eventName: String, indexName: String, objectIDsWithPositions: [(String, Int)], queryID: String, timestamp: Date?, userToken: String?) {
    didClick?((eventName, indexName, objectIDsWithPositions, queryID, timestamp, userToken))
  }

  func convertedAfterSearch(eventName: String, indexName: String, objectIDs: [String], queryID: String, timestamp: Date?, userToken: String?) {
    didConvert?((eventName, indexName, objectIDs, queryID, timestamp, userToken))
  }

  func viewed(eventName: String, indexName: String, objectIDs: [String], timestamp: Date?, userToken: String?) {
    didView?((eventName, indexName, objectIDs, timestamp, userToken))
  }
}
