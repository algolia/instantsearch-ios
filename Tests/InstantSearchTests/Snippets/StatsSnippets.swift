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
  
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let labelStatsController: LabelStatsController = LabelStatsController(label: UILabel())

    let statsConnector: StatsConnector = .init(searcher: searcher,
                                               controller: labelStatsController,
                                               presenter: DefaultPresenter.Stats.present)

    searcher.search()
    
    _ = statsConnector

  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let labelStatsController: LabelStatsController = LabelStatsController(label: UILabel())
    let statsInteractor: StatsInteractor = .init()
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(labelStatsController, presenter: DefaultPresenter.Stats.present)

    searcher.search()
  }
  
}
