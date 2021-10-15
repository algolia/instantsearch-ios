//
//  FilterTrackable.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
#if !InstantSearchCocoaPods
import InstantSearchInsights
#endif

protocol FilterTrackable {

  func viewed(eventName: EventName,
              indexName: IndexName,
              filters: [String],
              timestamp: Date?,
              userToken: UserToken?)

  func clicked(eventName: EventName,
               indexName: IndexName,
               filters: [String],
               timestamp: Date?,
               userToken: UserToken?)

  func converted(eventName: EventName,
                 indexName: IndexName,
                 filters: [String],
                 timestamp: Date?,
                 userToken: UserToken?)

}

extension Insights: FilterTrackable {}
