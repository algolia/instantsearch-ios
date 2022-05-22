//
//  MovieDemoController.swift
//  Examples
//
//  Created by Vladislav Fitc on 05/05/2022.
//

import Foundation
import InstantSearchCore

class MovieDemoController {

  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<Movie>>
  let searchBoxConnector: SearchBoxConnector

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(client: .tmdb,
                     indexName: .tmdbMovies)
    hitsInteractor = .init()
    searchBoxConnector = .init(searcher: searcher,
                               searchTriggeringMode: searchTriggeringMode)
    hitsInteractor.connectSearcher(searcher)
  }

}
