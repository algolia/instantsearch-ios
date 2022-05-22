//
//  SearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

enum MultiIndex {

  struct Movie: Codable {
    let title: String
  }

  struct Actor: Codable {
    let name: String
  }

  class SearchViewController: UIViewController {

    let searchController: UISearchController

    let searchBoxConnector: SearchBoxConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let actorHitsInteractor: HitsInteractor<Hit<Actor>>
    let movieHitsInteractor: HitsInteractor<Hit<Movie>>

    let searchResultsController: SearchResultsController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(client: .instantSearch)
      searchResultsController = .init()
      actorHitsInteractor = .init(infiniteScrolling: .off)
      movieHitsInteractor = .init(infiniteScrolling: .off)
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      searchBoxConnector = .init(searcher: searcher,
                                 controller: textFieldController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()

      configureUI()

      let actorsSearcher = searcher.addHitsSearcher(indexName: .actors)
      actorHitsInteractor.connectSearcher(actorsSearcher)
      searchResultsController.actorsHitsInteractor = actorHitsInteractor

      let moviesSearcher = searcher.addHitsSearcher(indexName: .movies)
      movieHitsInteractor.connectSearcher(moviesSearcher)
      searchResultsController.moviesHitsInteractor = movieHitsInteractor

      searcher.search()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }

    func configureUI() {
      title = "Multi-Index Search"
      view.backgroundColor = .systemBackground
      definesPresentationContext = true
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }

  }

}
