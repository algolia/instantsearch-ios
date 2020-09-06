//
//  StatsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class StatsSnippets {

  let statsInteractor = StatsInteractor()
  let statsConnector = StatsConnector(searcher: .init(appID: "", apiKey: "", indexName: ""))
  
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let statsConnector: StatsConnector = .init(searcher: searcher)

    searcher.search()
    
    _ = statsConnector

  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let statsInteractor: StatsInteractor = .init()
    statsInteractor.connectSearcher(searcher)

    searcher.search()
  }
  
  func connectControllerConnector() {
    let statsConnector: StatsConnector = /*...*/ self.statsConnector
    
    let labelStatsController: LabelStatsController = LabelStatsController(label: UILabel())

    statsConnector.interactor.connectController(labelStatsController) { stats -> String? in
      guard let stats = stats else {
        return "Error occured"
      }
      return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
    }
  }
  
  func connectControllerInteractor() {
    let statsInteractor: StatsInteractor = /*...*/ self.statsInteractor
    
    let labelStatsController: LabelStatsController = LabelStatsController(label: UILabel())

    statsInteractor.connectController(labelStatsController) { stats -> String? in
      guard let stats = stats else {
        return "Error occured"
      }
      return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
    }
  }

}
