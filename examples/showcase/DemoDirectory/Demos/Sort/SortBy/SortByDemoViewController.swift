//
//  SortByDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class SortByDemoViewController: UIViewController {
    
  var onClick: ((Int) -> Void)? = nil
  
  let controller: SortByDemoController

  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: ResultsViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.controller = .init()
    self.resultsViewController = .init(searcher: controller.searcher)
    self.searchController = .init(searchResultsController: resultsViewController)
    self.textFieldController = TextFieldController(searchBar: searchController.searchBar)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setup() {
    searchController.searchBar.delegate = self
    controller.statsConnector.connectController(resultsViewController.statsController)
    controller.hitsConnector.connectController(resultsViewController.hitsViewController)
    controller.queryInputConnector.connectController(textFieldController)
    controller.sortByConnector.connectController(self, presenter: controller.title(for:))
  }

}

extension SortByDemoViewController: UISearchBarDelegate {
    
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    onClick?(selectedScope)
  }
  
}

extension SortByDemoViewController: SelectableSegmentController {
      
  func setItems(items: [Int: String]) {
    searchController.searchBar.scopeButtonTitles = items.sorted(by: \.key).map(\.value)
  }

  
  func setSelected(_ selected: Int?) {
    if let index = selected {
      searchController.searchBar.selectedScopeButtonIndex = index
    }
  }
  
}


extension SortByDemoViewController {
  
  fileprivate func setupUI() {
    title = "Sort By"
    view.backgroundColor = .white
    definesPresentationContext = true
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

}

