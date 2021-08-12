//
//  RedirectGuideSnippets.swift
//  
//
//  Created by Vladislav Fitc on 13/10/2020.
//

import Foundation
import InstantSearch

class RedirectGuideSnippets {

  let index = SearchClient(appID: "", apiKey: "").index(withName: "")
  
  func addRedirectRule() {
    
    let rule = Rule(objectID: "a-rule-id")
      .set(\.conditions, to: [
        .init(anchoring: .is, pattern: .literal("star wars"))
      ])
      .set(\.consequence, to: Rule.Consequence()
            .set(\.userData, to: ["redirect": "https://www.google.com/#q=star+wars"])
      )
    
    index.saveRule(rule) { result in
      if case .success(let response) = result {
         print("Response: \(response)")
      }
    }
    
  }
  
  struct Redirect: Decodable {
    let url: URL
  }
  
  func redirectWidget() {
    
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
        
    let queryRuleCustomDataConnector = QueryRuleCustomDataConnector<Redirect>(searcher: searcher)
    
    queryRuleCustomDataConnector.interactor.onItemChanged.subscribe(with: self) { (_, redirect) in
      if let redirectURL = redirect?.url {
        /// perform redirect with URL
        
        _ = redirectURL // To supress warning
      }
    }
    
  }
  
  func configureIndex() {
    index.setSettings(Settings().set(\.attributesForFaceting, to: ["query_terms"])) { result in
      if case .success(let response) = result {
         print("Response: \(response)")
      }
    }
  }
  
  
}
