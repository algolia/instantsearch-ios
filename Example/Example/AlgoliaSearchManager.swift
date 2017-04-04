//
//  AlgoliaSearchManager.swift
//  BasicDemo
//
//  Created by Guy Daher on 22/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation

import Foundation
import InstantSearchCore
import AlgoliaSearch

class AlgoliaSearchManager {
    /// The singleton instance.
    static let instance = AlgoliaSearchManager()
    
    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    private let ALGOLIA_API_KEY = "1f6fd3a6fb973cb08419fe7d288fa4db"
    private let index: Index
    
    var searcher: Searcher
    
    private init() {
        
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        index = client.index(withName: ALGOLIA_INDEX_NAME)
        searcher = Searcher(index: index)
        
        searcher.params.attributesToRetrieve = ["name", "salePrice"]
        searcher.params.attributesToHighlight = ["name"]
        searcher.params.facets = ["category", "manufacturer"]
    }
}
