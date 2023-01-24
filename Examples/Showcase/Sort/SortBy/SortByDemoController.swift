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
  let searchBoxConnector: SearchBoxConnector
  let statsConnector: StatsConnector
  let hitsConnector: HitsConnector<Hit<StoreItem>>
  let sortByConnector: SortByConnector

  init() {
    searcher = HitsSearcher(client: .ecommerce,
                            indexName: .ecommerceProducts)
    searchBoxConnector = .init(searcher: searcher)
    hitsConnector = .init(searcher: searcher)
    statsConnector = .init(searcher: searcher)
    sortByConnector = .init(searcher: searcher,
                            indicesNames: [.ecommerceProducts,
                                           .ecommerceProductsAsc,
                                           .ecommerceProductsDesc],
                            selected: 0)
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false
  }

  func title(for indexName: IndexName) -> String {
    switch indexName {
    case .ecommerceProducts:
      return "Default"
    case .ecommerceProductsAsc:
      return "Price Asc"
    case .ecommerceProductsDesc:
      return "Price Desc"
    default:
      return indexName.rawValue
    }
  }
}
