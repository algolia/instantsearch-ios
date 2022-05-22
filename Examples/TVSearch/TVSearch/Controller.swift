//
//  Controller.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

class Controller {

  let demoController: MovieDemoController
  let hitsController: HitsObservableController<Hit<Movie>>
  let searchBoxController: SearchBoxObservableController
  let statsController: StatsTextObservableController
  let loadingController: LoadingObservableController

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
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
