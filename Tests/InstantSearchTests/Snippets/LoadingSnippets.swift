//
//  LoadingSnippets.swift
//  
//
//  Created by Vladislav Fitc on 06/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class LoadingSnippets {
  
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let activityIndicatorController: ActivityIndicatorController = .init(activityIndicator: UIActivityIndicatorView())
    let loadingConnector: LoadingConnector = .init(searcher: searcher,
                                                   controller: activityIndicatorController)
  
    // Execute a search which will spin the loading indicator until the results arrive
    searcher.search()
    
    _ = loadingConnector
  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let loadingInteractor: LoadingInteractor = .init()
    let activityIndicatorController: ActivityIndicatorController = .init(activityIndicator: UIActivityIndicatorView())

    loadingInteractor.connectSearcher(searcher)
    loadingInteractor.connectController(activityIndicatorController)

    // Execute a search which will spin the loading indicator until the results arrive
    searcher.search()
    
    _ = loadingInteractor
  }

}
