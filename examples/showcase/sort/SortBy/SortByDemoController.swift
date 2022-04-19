//
//  SortByDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class SortByDemoController {
  
  let searcher: HitsSearcher
  let queryInputConnector: QueryInputConnector
  let statsConnector: StatsConnector
  let hitsConnector: HitsConnector<Hit<StoreItem>>
  let sortByConnector: SortByConnector
  
  init() {
    self.searcher = HitsSearcher(client: .newDemo,
                                 indexName: Index.Ecommerce.products)
    self.queryInputConnector = .init(searcher: searcher)
    self.hitsConnector = .init(searcher: searcher)
    self.statsConnector = .init(searcher: searcher)
    sortByConnector = .init(searcher: searcher,
                            indicesNames: [Index.Ecommerce.products,
                                           Index.Ecommerce.productsAsc,
                                           Index.Ecommerce.productsDesc],
                            selected: 0)
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false
  }
  
  func title(for indexName: IndexName) -> String {
    switch indexName {
    case Index.Ecommerce.products:
      return "Default"
    case Index.Ecommerce.productsAsc:
      return "Price Asc"
    case Index.Ecommerce.productsDesc:
      return "Price Desc"
    default:
      return indexName.rawValue
    }
  }
  
}
