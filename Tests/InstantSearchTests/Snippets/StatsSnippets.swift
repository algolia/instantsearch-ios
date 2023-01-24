//
//  StatsSnippets.swift
//
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
  import UIKit

  class StatsSnippets {
    func widgetSnippet() {
      let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                         apiKey: "YourSearchOnlyAPIKey",
                                         indexName: "YourIndexName")
      let labelStatsController = LabelStatsController(label: UILabel())

      let statsConnector: StatsConnector = .init(searcher: searcher,
                                                 controller: labelStatsController,
                                                 presenter: DefaultPresenter.Stats.present)

      searcher.search()

      _ = statsConnector
    }

    func advancedSnippet() {
      let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                         apiKey: "YourSearchOnlyAPIKey",
                                         indexName: "YourIndexName")
      let labelStatsController = LabelStatsController(label: UILabel())
      let statsInteractor: StatsInteractor = .init()
      statsInteractor.connectSearcher(searcher)
      statsInteractor.connectController(labelStatsController, presenter: DefaultPresenter.Stats.present)

      searcher.search()
    }
  }
#endif
