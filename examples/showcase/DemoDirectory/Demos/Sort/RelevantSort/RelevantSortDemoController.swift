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

  struct Item: Codable {
    let name: String
  }
  
  let searcher: HitsSearcher
  let queryInputConnector: QueryInputConnector
  let hitsConnector: HitsConnector<Item>
  let sortByConnector: SortByConnector
  let relevantSortConnector: RelevantSortConnector
  let statsConnector: StatsConnector
  
  init<SSC: SelectableSegmentController, RSC: RelevantSortController, HC: HitsController, QIC: QueryInputController, SC: StatsTextController>(sortByController: SSC,
                                                                                                                                              relevantSortController: RSC,
                                                                                                                                              hitsController: HC,
                                                                                                                                              queryInputController: QIC,
                                                                                                                                              statsController: SC) where RSC.Item == RelevantSortConnector.TextualRepresentation?, HC.DataSource == HitsInteractor<Item>, SSC.SegmentKey == Int {
    let indices: [IndexName] = [
      "test_Bestbuy",
      "test_Bestbuy_vr_price_asc",
      "test_Bestbuy_replica_price_asc"
    ]
    self.searcher = .init(appID: "C7RIRJRYR9",
                          apiKey: "6861aeb4f69b81db206d49ddb9f1dc1e",
                          indexName: indices.first!)
    self.queryInputConnector = .init(searcher: searcher,
                                     controller: queryInputController)
    self.sortByConnector = .init(searcher: searcher,
                                 indicesNames: indices,
                                 selected: 0,
                                 controller: sortByController) { indexName in
      switch indexName {
      case "test_Bestbuy":
        return "Most relevant"
      case "test_Bestbuy_vr_price_asc":
        return "Relevant Sort - Lowest Price"
      case "test_Bestbuy_replica_price_asc":
        return "Hard Sort - Lowest Price"
      default:
        return indexName.rawValue
      }
    }
    self.relevantSortConnector = .init(searcher: searcher,
                                       controller: relevantSortController)
    self.hitsConnector = .init(searcher: searcher,
                               controller: hitsController)
    self.statsConnector = .init(searcher: searcher,
                                controller: statsController)
    searcher.search()
  }
  
}

import SwiftUI


