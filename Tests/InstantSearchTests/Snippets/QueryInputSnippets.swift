//
//  QueryInputSnippets.swift
//  
//
//  Created by Vladislav Fitc on 05/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

class QueryInputSnippets {
    
  func widgetExample() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
    let queryInputConnector: QueryInputConnector = .init(searcher: searcher,
                                                         searchTriggeringMode: .searchAsYouType,
                                                         controller: searchBarController)
    
    _ = queryInputConnector
    
  }
  
  func advancedExample() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let queryInputInteractor: QueryInputInteractor = .init()
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())

    queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    queryInputInteractor.connectController(searchBarController)
  }
  
}
#endif
