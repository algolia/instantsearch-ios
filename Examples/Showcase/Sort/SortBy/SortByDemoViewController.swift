//
//  SortByDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import InstantSearch
import UIKit

class SortByDemoViewController: UIViewController {
  let demoController: SortByDemoController

  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: ResultsViewController

  var onClick: ((Int) -> Void)?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = .init()
    resultsViewController = .init(searcher: demoController.searcher)
    searchController = .init(searchResultsController: resultsViewController)
    textFieldController = TextFieldController(searchBar: searchController.searchBar)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  private func setup() {
    searchController.searchBar.delegate = self
    demoController.statsConnector.connectController(resultsViewController.statsController)
    demoController.hitsConnector.connectController(resultsViewController.hitsViewController)
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.sortByConnector.connectController(self, presenter: demoController.title(for:))
  }

  private func setupUI() {
    title = "Sort By"
    view.backgroundColor = .systemBackground
    definesPresentationContext = true
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
}

extension SortByDemoViewController: UISearchBarDelegate {
  func searchBar(_: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
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
