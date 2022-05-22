//
//  MultiIndexDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore

class MultiIndexDemoController {

  let multiSearcher: MultiSearcher
  let suggestionsHitsConnector: HitsConnector<QuerySuggestion>
  let productsHitsConnector: HitsConnector<Hit<StoreItem>>
  let searchBoxConnector: SearchBoxConnector

  init() {
    multiSearcher = .init(client: .ecommerce)
    let suggestionsSearcher = multiSearcher.addHitsSearcher(indexName: .ecommerceSuggestions)
    let productsSearcher = multiSearcher.addHitsSearcher(indexName: .ecommerceProducts)
    searchBoxConnector = .init(searcher: multiSearcher)
    productsHitsConnector = .init(searcher: productsSearcher)
    suggestionsHitsConnector = .init(searcher: suggestionsSearcher)
    multiSearcher.search()
  }

}
