//
//  SearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 10/09/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

enum QuerySuggestionsCategories {

  class SearchViewController: UIViewController {

    let searchController: UISearchController

    let searchBoxConnector: SearchBoxConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let categoriesInteractor: FacetListInteractor
    let suggestionsInteractor: HitsInteractor<QuerySuggestion>

    let searchResultsController: SearchResultsController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(client: .instantSearch)
      searchResultsController = .init()
      categoriesInteractor = .init()
      suggestionsInteractor = .init(infiniteScrolling: .off)
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

      let facetsSearcher = searcher.addFacetsSearcher(indexName: .instantSearch,
                                                      attribute: "categories")
      categoriesInteractor.connectFacetSearcher(facetsSearcher)
      searchResultsController.categoriesInteractor = categoriesInteractor

      let suggestionsSearcher = searcher.addHitsSearcher(indexName: .instantSearchSuggestions)
      suggestionsInteractor.connectSearcher(suggestionsSearcher)
      searchResultsController.suggestionsInteractor = suggestionsInteractor

      searchResultsController.didSelectSuggestion = { [weak self] suggestion in
        self?.searchBoxConnector.interactor.query = suggestion
      }

      searcher.search()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }

    func configureUI() {
      title = "Suggestions & Categories"
      view.backgroundColor = .systemBackground
      definesPresentationContext = true
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }

  }

}
