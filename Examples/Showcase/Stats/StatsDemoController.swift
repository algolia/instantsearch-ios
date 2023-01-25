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
  let searchBoxConnector: SearchBoxConnector

  init() {
    searcher = HitsSearcher(client: .instantSearch,
                            indexName: .movies)
    searchBoxConnector = .init(searcher: searcher)
    statsConnector = .init(searcher: searcher)
    searcher.search()
  }
}
