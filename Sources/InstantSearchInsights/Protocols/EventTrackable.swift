//
//  EventTrackable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol EventTrackable {
  func view(eventName: String,
            indexName: String,
            userToken: String?,
            timestamp: Date?,
            objectIDs: [String])

  func view(eventName: String,
            indexName: String,
            userToken: String?,
            timestamp: Date?,
            filters: [String])

  func click(eventName: String,
             indexName: String,
             userToken: String?,
             timestamp: Date?,
             objectIDs: [String])

  func click(eventName: String,
             indexName: String,
             userToken: String?,
             timestamp: Date?,
             objectIDs: [String],
             positions: [Int],
             queryID: String)

  func click(eventName: String,
             indexName: String,
             userToken: String?,
             timestamp: Date?,
             filters: [String])

  func conversion(eventName: String,
                  indexName: String,
                  userToken: String?,
                  timestamp: Date?,
                  objectIDs: [String])

  func conversion(eventName: String,
                  indexName: String,
                  userToken: String?,
                  timestamp: Date?,
                  objectIDs: [String],
                  queryID: String)

  func conversion(eventName: String,
                  indexName: String,
                  userToken: String?,
                  timestamp: Date?,
                  filters: [String])
}
