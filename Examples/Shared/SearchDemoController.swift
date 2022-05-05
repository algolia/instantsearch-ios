//
//  SearchDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore

class SearchDemoController {
  
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<StoreItem>>
  let queryInputConnector: QueryInputConnector
  let statsConnector: StatsConnector
  let loadingConnector: LoadingConnector

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(client: .ecommerce,
                     indexName: .ecommerceProducts)
    hitsInteractor = .init()
    queryInputConnector = .init(searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    statsConnector = .init(searcher: searcher)
    loadingConnector = .init(searcher: searcher)
    hitsInteractor.connectSearcher(searcher)
  }
  
}
