//
//  QueryRuleCustomDataDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import InstantSearchCore

class QueryRuleCustomDataDemoController {
      
  let searcher: HitsSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<Hit<Product>>
  let queryRuleCustomDataConnector: QueryRuleCustomDataConnector<Banner>
  
  static let helpMessage = """
  - Type "iphone" to show image banner. Click banner to redirect.\n
  - Type "discount" to show textual banner. Click banner to redirect.\n
  - Type "help" to activate redirect on submit. Submit by clicking "search" button on the keyboard to redirect.
  """
  
  init() {
    searcher = HitsSearcher(client: .demo, indexName: "instant_search")
    self.queryInputInteractor = .init()
    self.hitsInteractor = .init()
    self.queryRuleCustomDataConnector = .init(searcher: searcher)
    setupConnections()
  }
  
  func setupConnections() {
     queryInputInteractor.connectSearcher(searcher)
     hitsInteractor.connectSearcher(searcher)
  }
  
}
