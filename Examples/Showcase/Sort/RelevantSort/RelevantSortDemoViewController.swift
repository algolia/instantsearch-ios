//
//  RelevantSortDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class RelevantSortDemoViewController: UIViewController {

  let demoController: RelevantSortDemoController

  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: RelevantSortResultsViewController

  var onClick: ((Int) -> Void)?

  init() {
    resultsViewController = .init()
    self.searchController = .init(searchResultsController: resultsViewController)
    self.textFieldController = .init(searchBar: searchController.searchBar)
    self.demoController = .init()
    super.init(nibName: nil, bundle: nil)
    demoController.sortByConnector.connectController(self, presenter: demoController.title(for:))
    setup()
  }

  required init?(coder: NSCoder) {
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
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.relevantSortConnector.connectController(resultsViewController.relevantSortController)
    demoController.hitsConnector.connectController(resultsViewController.hitsController)
    demoController.statsConnector.connectController(resultsViewController.statsController)
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    definesPresentationContext = true
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }

}

extension RelevantSortDemoViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    onClick?(selectedScope)
  }

}

extension RelevantSortDemoViewController: SelectableSegmentController {

  func setSelected(_ selected: Int?) {
    if let index = selected {
      searchController.searchBar.selectedScopeButtonIndex = index
    }
  }

  func setItems(items: [Int: String]) {
    searchController.searchBar.scopeButtonTitles = items.sorted(by: \.key).map(\.value)
  }

}
