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
  
  private let loadingInteractor: LoadingInteractor = .init()
  private let loadingConnector = LoadingConnector(searcher: SingleIndexSearcher(appID: "", apiKey: "", indexName: ""))
    
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let loadingConnector: LoadingConnector = .init(searcher: searcher)
  
    // Execute a search which will spin the loading indicator until the results arrive
    searcher.search()
    
    _ = loadingConnector
  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let loadingInteractor: LoadingInteractor = .init()
    loadingInteractor.connectSearcher(searcher)

    // Execute a search which will spin the loading indicator until the results arrive
    searcher.search()
    
    _ = loadingInteractor
  }
  
  func connectViewConnector() {
    let loadingConnector: LoadingConnector = /*...*/ self.loadingConnector
    let activityIndicatorController: ActivityIndicatorController = .init(activityIndicator: UIActivityIndicatorView())
    loadingConnector.interactor.connectController(activityIndicatorController)
  }
  
  func connectViewAdvanced() {
    let loadingInteractor: LoadingInteractor = /*...*/ self.loadingInteractor
    let activityIndicatorController: ActivityIndicatorController = .init(activityIndicator: UIActivityIndicatorView())
    loadingInteractor.connectController(activityIndicatorController)
  }
  
}
