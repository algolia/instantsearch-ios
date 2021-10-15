//
//  TestFiltersTracker.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 20/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

class TestFiltersTracker: FilterTrackable {

  enum EventType { case view, click, convert }

  var did: (((EventType, eventName: EventName, indexName: IndexName, filters: [String], timestamp: Date?, userToken: UserToken?)) -> Void)?

  func viewed(eventName: EventName,
              indexName: IndexName,
              filters: [String],
              timestamp: Date?,
              userToken: UserToken?) {
    did?((.view, eventName, indexName, filters, timestamp, userToken))
  }

  func clicked(eventName: EventName,
               indexName: IndexName,
               filters: [String],
               timestamp: Date?,
               userToken: UserToken?) {
    did?((.click, eventName, indexName, filters, timestamp, userToken))
  }

  func converted(eventName: EventName,
                 indexName: IndexName,
                 filters: [String],
                 timestamp: Date?,
                 userToken: UserToken?) {
    did?((.convert, eventName, indexName, filters, timestamp, userToken))
  }

}
