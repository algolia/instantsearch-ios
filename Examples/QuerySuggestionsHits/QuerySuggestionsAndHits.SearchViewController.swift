//
//  SearchViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import UIKit
import InstantSearch

enum QuerySuggestionsAndHits {

  class SearchViewController: UIViewController {

    let searchController: UISearchController

    let searchBoxConnector: SearchBoxConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let suggestionsInteractor: HitsInteractor<QuerySuggestion>
    let hitsInteractor: HitsInteractor<Hit<Product>>

    let searchResultsController: SearchResultsController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(client: .instantSearch)
      searchResultsController = .init(style: .plain)
      suggestionsInteractor = .init(infiniteScrolling: .off)
      hitsInteractor = .init(infiniteScrolling: .off)
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

      let suggestionsSearcher = searcher.addHitsSearcher(indexName: .instantSearchSuggestions)
      suggestionsSearcher.request.query.hitsPerPage = 5
      suggestionsInteractor.connectSearcher(suggestionsSearcher)
      searchResultsController.suggestionsHitsInteractor = suggestionsInteractor

      let hitsSearchers = searcher.addHitsSearcher(indexName: .instantSearch)
      hitsInteractor.connectSearcher(hitsSearchers)
      searchResultsController.hitsInteractor = hitsInteractor

      searcher.search()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }

    func configureUI() {
      title = "Suggestions & Hits"
      view.backgroundColor = .systemBackground
      definesPresentationContext = true
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }

  }

}
