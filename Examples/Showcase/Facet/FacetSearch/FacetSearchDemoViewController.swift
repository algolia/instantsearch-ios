//
//  FacetSearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class FacetSearchDemoViewController: UIViewController {

  let demoController: FacetSearchDemoController
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let facetListController: FacetListTableController
  let filterDebugViewController: FilterDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    facetListController = FacetListTableController(tableView: .init())
    textFieldController = TextFieldController(searchBar: searchBar)
    demoController = FacetSearchDemoController()
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupUI()
  }

}

private extension FacetSearchDemoViewController {

  func setup() {
    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    demoController.facetListConnector.connectController(facetListController)
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
  }

  func setupUI() {
    view.backgroundColor = .systemBackground
    let tableView = facetListController.tableView
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    let filterDebugView = filterDebugViewController.view!
    filterDebugView.translatesAutoresizingMaskIntoConstraints = false
    filterDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    let filterDebugViewContainer = UIView()
    filterDebugViewContainer.translatesAutoresizingMaskIntoConstraints = false
    filterDebugViewContainer.addSubview(filterDebugView)
    filterDebugView.pin(to: filterDebugViewContainer, insets: .init(top: 0, left: 10, bottom: 0, right: -10))
    let stackView = UIStackView()
    stackView.spacing = 5
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    stackView.pin(to: view)
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(filterDebugViewContainer)
    stackView.addArrangedSubview(tableView)
  }

}
