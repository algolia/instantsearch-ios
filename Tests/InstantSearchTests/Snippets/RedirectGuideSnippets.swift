//
//  RedirectGuideSnippets.swift
//
//
//  Created by Vladislav Fitc on 13/10/2020.
//

import AlgoliaCore
import Foundation
import InstantSearch
import AlgoliaSearch

class RedirectGuideSnippets {
  let client = try! SearchClient(appID: "testAppID", apiKey: "testApiKey")
  let indexName = ""

  func addRedirectRule() {
    // In v9, Rule requires consequence in initializer
    let rule = Rule(
      objectID: "a-rule-id",
      conditions: [
        SearchCondition(pattern: "star wars", anchoring: .is)
      ],
      consequence: SearchConsequence(userData: AnyCodable(["redirect": "https://www.google.com/#q=star+wars"]))
    )

    Task {
      do {
        let response = try await client.saveRule(indexName: indexName,
                                                 objectID: rule.objectID,
                                                 rule: rule)
        print("Response: \(response)")
      } catch {
        print("Error: \(error)")
      }
    }
  }

  struct Redirect: Decodable {
    let url: URL
  }

  func redirectWidget() {
    let searcher: HitsSearcher = try! .init(appID: "YourApplicationID",
                                            apiKey: "YourSearchOnlyAPIKey",
                                            indexName: "YourIndexName")

    let queryRuleCustomDataConnector = QueryRuleCustomDataConnector<Redirect>(searcher: searcher)

    queryRuleCustomDataConnector.interactor.onItemChanged.subscribe(with: self) { _, redirect in
      if let redirectURL = redirect?.url {
        /// perform redirect with URL

        _ = redirectURL // To supress warning
      }
    }
  }

  func configureIndex() {
    Task {
      do {
        let response = try await client.setSettings(indexName: indexName,
                                                    indexSettings: AlgoliaSearch.IndexSettings().set(\.attributesForFaceting, to: ["query_terms"]))
        print("Response: \(response)")
      } catch {
        print("Error: \(error)")
      }
    }
  }
}
