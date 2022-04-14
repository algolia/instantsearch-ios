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
  let queryInputConnector: QueryInputConnector
  
  init() {
    multiSearcher = MultiSearcher(appID: SearchClient.newDemo.applicationID,
                                  apiKey: SearchClient.newDemo.apiKey)
    let suggestionsSearcher = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.suggestions)
    let productsSearcher = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.products)
    queryInputConnector = .init(searcher: multiSearcher)
    productsHitsConnector = .init(searcher: productsSearcher)
    suggestionsHitsConnector = .init(searcher: suggestionsSearcher)
    multiSearcher.search()
  }
  
}
