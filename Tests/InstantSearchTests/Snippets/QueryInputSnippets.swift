//
//  QueryInputSnippets.swift
//  
//
//  Created by Vladislav Fitc on 05/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class QueryInputSnippets {
  
  let queryInputInteractor = QueryInputInteractor()
  let queryInputConnector = QueryInputConnector(searcher: SingleIndexSearcher(appID: "", apiKey: "", indexName: ""))
  
  func widgetExample() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let queryInputConnector: QueryInputConnector = .init(searcher: searcher,
                                                         searchTriggeringMode: .searchAsYouType)
    
    _ = queryInputConnector
    
  }
  
  func advancedExample() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    
    let queryInputInteractor: QueryInputInteractor = .init()

    queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
  }
  
  func connectControllerConnector() {
    let queryInputConnector: QueryInputConnector = /*...*/ self.queryInputConnector
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
    queryInputConnector.interactor.connectController(searchBarController)
  }
  
  func connectControllerInteractor() {
    let queryInputInteractor: QueryInputInteractor = /*...*/ self.queryInputInteractor
    let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
    queryInputInteractor.connectController(searchBarController)
  }
  
}
