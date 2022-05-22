//
//  EcommerceDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore

class EcommerceDemoController {

  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<StoreItem>>
  let searchBoxConnector: SearchBoxConnector
  let statsConnector: StatsConnector
  let loadingConnector: LoadingConnector

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(client: .ecommerce,
                     indexName: .ecommerceProducts)
    hitsInteractor = .init()
    searchBoxConnector = .init(searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    statsConnector = .init(searcher: searcher)
    loadingConnector = .init(searcher: searcher)
    hitsInteractor.connectSearcher(searcher)
  }

}
