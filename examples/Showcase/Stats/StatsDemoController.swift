//
//  StatsDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class StatsDemoController {
  
  let searcher: HitsSearcher
  let statsConnector: StatsConnector
  let queryInputConnector: QueryInputConnector

  init() {
    self.searcher = HitsSearcher(client: .instantSearch, indexName: "mobile_demo_movies")
    self.queryInputConnector = .init(searcher: searcher)
    self.statsConnector = .init(searcher: searcher)
    searcher.search()
  }
  
  
}
