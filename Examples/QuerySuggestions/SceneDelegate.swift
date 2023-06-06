//
//  SceneDelegate.swift
//  QuerySuggestionsGuide
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import UIKit
import SwiftUI
import InstantSearchCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  let searcher = HitsSearcher(appID: "latency",
                              apiKey: "af044fb0788d6bb15f807e4420592bc5",
                              indexName: "instant_search_ecommerce")
  let filterState = FilterState()

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
//    let uikitViewController = QuerySuggestionsDemoViewController()
//    let swiftUIViewController = UIHostingController(rootView: SearchView())
    setMain(UIViewController(), for: scene)
    searcher.connectFilterState(filterState)
    filterState[and: "categories"].add(Filter.Facet(attribute: "categories", stringValue: "TVs"))
    let types = [
      "45\"-50\"  tv\'s",
      "61\"-100 tv\'s",
      "Small lcd",
      "Mht 51\" - 60\" tv\'s",
      "Mid 32\" lcd",
      "51\"-60\" tv\'s",
      "Mht 61\"-100\" tv\'s",
      "Mht 30\"- 50\"",
      "Mid 40\"-45\" lcd"]
    filterState[and: "type"].add(Filter.Facet(attribute: "type", stringValue: types[1]))
    searcher.onResults.subscribe(with: self) { _, response in
      guard let facets = response.facets else { return }
      for (attribute, values) in facets {
        print(">>> facet", attribute, values.map(\.value))
      }
    }
//    searcher.isDisjunctiveFacetingEnabled = false
    searcher.onError.subscribe(with: self) { _, error in
      print(">>> error", error)
    }
    searcher.request.query.facets = ["type"]
    let typeValue = types[1].replacingOccurrences(of: "\"", with: "\\\"")
//    searcher.request.query.filters = """
//    ( "categories":"TVs" ) AND ( "type":"\(typeValue)" )
//    """
//    print(">>>", searcher.request.query.filters!)
//    searcher.request.query.filters = "\"categories\":\"TVs\""
    searcher.search()
  }
}
