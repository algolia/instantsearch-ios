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
  let searchBoxController: SearchBoxObservableController

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = MovieDemoController()
    hitsController = HitsObservableController()
    searchBoxController = SearchBoxObservableController()
    demoController.searchBoxConnector.connectController(searchBoxController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }

}
