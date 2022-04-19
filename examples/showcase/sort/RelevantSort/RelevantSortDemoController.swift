//
//  RelevantSortDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 03/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class RelevantSortDemoController {
  
  let searcher: HitsSearcher
  let queryInputConnector: QueryInputConnector
  let hitsConnector: HitsConnector<Hit<Product>>
  let sortByConnector: SortByConnector
  let relevantSortConnector: RelevantSortConnector
  let statsConnector: StatsConnector
  
  init() {
    let indices: [IndexName] = [
      "test_Bestbuy",
      "test_Bestbuy_vr_price_asc",
      "test_Bestbuy_replica_price_asc"
    ]
    self.searcher = .init(appID: "C7RIRJRYR9",
                          apiKey: "6861aeb4f69b81db206d49ddb9f1dc1e",
                          indexName: indices.first!)
    self.queryInputConnector = .init(searcher: searcher)
    self.sortByConnector = .init(searcher: searcher,
                                 indicesNames: indices,
                                 selected: 0)
    self.relevantSortConnector = .init(searcher: searcher)
    self.hitsConnector = .init(searcher: searcher)
    self.statsConnector = .init(searcher: searcher)
    searcher.search()
  }
  
}

import SwiftUI


