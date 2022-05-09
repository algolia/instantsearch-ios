//
//  SearchBoxSnippets.swift
//  
//
//  Created by Vladislav Fitc on 05/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

class SearchBoxSnippets {
  
  func widgetExample() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                       apiKey: "YourSearchOnlyAPIKey",
                                       indexName: "YourIndexName")
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
    let searchBoxConnector: SearchBoxConnector = .init(searcher: searcher,
                                                       searchTriggeringMode: .searchAsYouType,
                                                       controller: searchBarController)
    
    _ = searchBoxConnector
    
  }
  
  func advancedExample() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                       apiKey: "YourSearchOnlyAPIKey",
                                       indexName: "YourIndexName")
    let searchBoxInteractor: SearchBoxInteractor = .init()
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
    
    searchBoxInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    searchBoxInteractor.connectController(searchBarController)
  }
  
}
#endif
