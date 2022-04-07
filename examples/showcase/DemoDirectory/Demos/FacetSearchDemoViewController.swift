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

  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let facetListController: FacetListTableController
  let controller: FacetSearchDemoController
  let searchStateViewController: SearchDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    facetListController = FacetListTableController(tableView: .init())
    textFieldController = TextFieldController(searchBar: searchBar)
    searchStateViewController = SearchDebugViewController()
    controller = .init(facetListController: facetListController,
                       queryInputController: textFieldController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension FacetSearchDemoViewController {
  
  func setup() {
    searchStateViewController.connectFilterState(controller.filterState)
    searchStateViewController.connectFacetSearcher(controller.facetSearcher)
  }

  func setupUI() {
    view.backgroundColor = .white
    let tableView = facetListController.tableView
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchStateViewController.view.translatesAutoresizingMaskIntoConstraints = false
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 5
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(searchStateViewController.view)
    stackView.addArrangedSubview(tableView)
  }

}

