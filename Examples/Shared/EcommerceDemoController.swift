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
  
  var lastRequestTimeStamp: TimeInterval? = nil

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(client: .ecommerce,
                     indexName: .ecommerceProducts)
    hitsInteractor = .init()
    searchBoxConnector = .init(searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    statsConnector = .init(searcher: searcher)
    loadingConnector = .init(searcher: searcher)
    hitsInteractor.connectSearcher(searcher)
    
    searcher.onSearch.subscribe(with: self) { controller, _ in
      controller.lastRequestTimeStamp = Date().timeIntervalSince1970
    }
    
    let threshold: TimeInterval = 0.5
    searcher.shouldTriggerSearchForQuery = { query in
      if let lastRequestTimeStamp = self.lastRequestTimeStamp {
        let currentTimeStamp = Date().timeIntervalSince1970
        let diff = currentTimeStamp - lastRequestTimeStamp
        print("diff \(diff), \(diff > threshold)")
        return diff > threshold
      }
      return true
    }

  }
}
