//
//  FilterTrackable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchInsights

protocol FilterTrackable {

  func viewed(eventName: EventName,
              indexName: IndexName,
              filters: [String],
              userToken: UserToken?)

  func clicked(eventName: EventName,
               indexName: IndexName,
               filters: [String],
               userToken: UserToken?)

  func converted(eventName: EventName,
                 indexName: IndexName,
                 filters: [String],
                 userToken: UserToken?)

}

extension Insights: FilterTrackable {

  func viewed(eventName: EventName, indexName: IndexName, filters: [String], userToken: UserToken?) {
    self.viewed(eventName: eventName.rawValue, indexName: indexName.rawValue, filters: filters, userToken: userToken?.rawValue)
  }

  func clicked(eventName: EventName, indexName: IndexName, filters: [String], userToken: UserToken?) {
    self.clicked(eventName: eventName.rawValue, indexName: indexName.rawValue, filters: filters, userToken: userToken?.rawValue)
  }

  func converted(eventName: EventName, indexName: IndexName, filters: [String], userToken: UserToken?) {
    self.converted(eventName: eventName.rawValue, indexName: indexName.rawValue, filters: filters, userToken: userToken?.rawValue)
  }
}
