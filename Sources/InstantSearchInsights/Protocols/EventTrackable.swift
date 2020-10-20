//
//  EventTrackable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient
// swiftlint:disable function_parameter_count
protocol EventTrackable {

    func view(eventName: EventName,
              indexName: IndexName,
              userToken: UserToken?,
              objectIDs: [ObjectID])

    func view(eventName: EventName,
              indexName: IndexName,
              userToken: UserToken?,
              filters: [String])

    func click(eventName: EventName,
               indexName: IndexName,
               userToken: UserToken?,
               objectIDs: [ObjectID])

    func click(eventName: EventName,
               indexName: IndexName,
               userToken: UserToken?,
               objectIDs: [ObjectID],
               positions: [Int],
               queryID: QueryID)

    func click(eventName: EventName,
               indexName: IndexName,
               userToken: UserToken?,
               filters: [String])

    func conversion(eventName: EventName,
                    indexName: IndexName,
                    userToken: UserToken?,
                    objectIDs: [ObjectID])

    func conversion(eventName: EventName,
                    indexName: IndexName,
                    userToken: UserToken?,
                    objectIDs: [ObjectID],
                    queryID: QueryID)

    func conversion(eventName: EventName,
                    indexName: IndexName,
                    userToken: UserToken?,
                    filters: [String])

}
