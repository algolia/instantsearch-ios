//
//  SearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SearchDemoViewController: UIViewController {

  let demoController: EcommerceDemoController
  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: ResultsViewController

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = EcommerceDemoController(searchTriggeringMode: searchTriggeringMode)
    resultsViewController = .init(searcher: demoController.searcher)
    searchController = .init(searchResultsController: resultsViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    super.init(nibName: .none, bundle: .none)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.hitsInteractor.connectController(resultsViewController.hitsViewController)
    demoController.searcher.search()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  private func setupUI() {
    title = "Search"
    view.backgroundColor = .systemBackground
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }

}
