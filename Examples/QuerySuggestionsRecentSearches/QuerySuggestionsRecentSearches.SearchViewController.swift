//
//  SearchViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 03/11/2021.
//

import Foundation
import InstantSearch
import UIKit

enum QuerySuggestionsAndRecentSearches {

  class SearchViewController: UIViewController {

    let searchController: UISearchController

    let searchBoxConnector: SearchBoxConnector
    let textFieldController: TextFieldController

    let hitsSearcher: HitsSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>

    let searchResultsController: SearchResultsController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      hitsSearcher = .init(client: .instantSearch,
                           indexName: .instantSearchSuggestions)
      searchResultsController = .init()
      hitsInteractor = .init()
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      searchBoxConnector = .init(searcher: hitsSearcher,
                                 controller: textFieldController)
      hitsInteractor.connectSearcher(hitsSearcher)
      hitsInteractor.connectController(searchResultsController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      searchResultsController.onSelection = { [weak self] in
        self?.searchBoxConnector.interactor.query = $0
      }
      searchController.searchBar.searchTextField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingDidEndOnExit)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      hitsSearcher.search()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }

    func configureUI() {
      title = "Recent Searches & Suggestions"
      view.backgroundColor = .systemBackground
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }

    @objc func textFieldSubmitted() {
      guard let text = searchController.searchBar.text else { return }
      if let alreadyPresentIndex = searchResultsController.recentSearches.firstIndex(where: { $0 == text }) {
        searchResultsController.recentSearches.remove(at: alreadyPresentIndex)
      }
      searchResultsController.recentSearches.insert(text, at: searchResultsController.recentSearches.startIndex)
      searchResultsController.tableView.reloadData()
    }

  }

}
