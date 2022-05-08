//
//  Controller.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI

class Controller {
  
  let demoController: MovieDemoController
  let hitsController: HitsObservableController<Hit<Movie>>
  let queryInputController: QueryInputObservableController
  
  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    queryInputController = QueryInputObservableController()
    demoController.queryInputConnector.connectController(queryInputController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }
  
}
