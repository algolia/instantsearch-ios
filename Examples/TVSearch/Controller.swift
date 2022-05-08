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
  let queryInputController: QueryInputObservableController
  let statsController: StatsTextObservableController
  let loadingController: LoadingObservableController
  
  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    queryInputController = QueryInputObservableController()
    statsController = StatsTextObservableController()
    loadingController = LoadingObservableController()
    demoController.queryInputConnector.connectController(queryInputController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }
  
}
