//
//  Controller.swift
//  MediaDemo
//
//  Created by Vladislav Fitc on 09/05/2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI

class Controller {
  let demoController: MovieDemoController
  let hitsController: HitsObservableController<Hit<Movie>>
  let searchBoxController: SearchBoxObservableController
  let statsController: StatsTextObservableController
  let loadingController: LoadingObservableController

  init(searchTriggeringMode _: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    searchBoxController = SearchBoxObservableController()
    statsController = StatsTextObservableController()
    loadingController = LoadingObservableController()
    demoController.searchBoxConnector.connectController(searchBoxController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }
}
