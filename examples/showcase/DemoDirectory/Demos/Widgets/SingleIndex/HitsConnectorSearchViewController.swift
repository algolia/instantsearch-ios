//
//  HitsConnectorSearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class HitsConnectorSearchViewController: UIViewController {
  
  let searchController: UISearchController
  var textFieldController: TextFieldController
  let hitsTableViewController: SearchResultsViewController

  let queryInputInteractor: QueryInputInteractor
  let hitsConnector: HitsConnector<Item>
  let statsInteractor: StatsInteractor

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    hitsTableViewController = .init(style: .plain)
    searchController = .init(searchResultsController: hitsTableViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    
    let searcher = HitsSearcher(appID: "latency",
                                apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                indexName: "bestbuy")
    hitsConnector = HitsConnector(searcher: searcher)
    queryInputInteractor = .init()
    statsInteractor = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    hitsConnector.connect()
    hitsConnector.interactor.connectController(hitsTableViewController)
    queryInputInteractor.connectSearcher(searcher)
    queryInputInteractor.connectController(textFieldController)
    statsInteractor.connectController(self)
    hitsConnector.searcher.search()
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    view.backgroundColor = .white
    navigationItem.searchController = searchController
    navigationItem.largeTitleDisplayMode = .never
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.isActive = true
    searchController.becomeFirstResponder()
  }
    
}

extension HitsConnectorSearchViewController: StatsTextController {
  
  func setItem(_ item: String?) {
    searchController.searchBar.scopeButtonTitles = item.flatMap { [$0] }
  }
  
}
