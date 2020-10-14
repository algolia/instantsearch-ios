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
              objectIDs: [String])
    
    func view(eventName: String,
              indexName: String,
              userToken: String?,
              filters: [String])
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               objectIDs: [String])
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               objectIDs: [String],
               positions: [Int],
               queryID: String)
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               filters: [String])
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    objectIDs: [String])
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    objectIDs: [String],
                    queryID: String)
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    filters: [String])
    
}
