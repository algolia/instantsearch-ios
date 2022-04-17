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
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let hitsSearcher: HitsSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>
    
    let searchResultsController: SearchResultsController
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      hitsSearcher = .init(appID: "latency",
                           apiKey: "afc3dd66dd1293e2e2736a5a51b05c0a",
                           indexName: "instantsearch_query_suggestions")
      searchResultsController = .init()
      hitsInteractor = .init()
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: hitsSearcher,
                                  controller: textFieldController)
      hitsInteractor.connectSearcher(hitsSearcher)
      hitsInteractor.connectController(searchResultsController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      searchResultsController.onSelection = { [weak self] in
        self?.queryInputConnector.interactor.query = $0
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
      view.backgroundColor = .white
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
