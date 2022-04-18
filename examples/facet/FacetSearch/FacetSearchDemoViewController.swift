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
  let searchDebugViewController: SearchDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    facetListController = FacetListTableController(tableView: .init())
    textFieldController = TextFieldController(searchBar: searchBar)
    controller = .init(facetListController: facetListController,
                       queryInputController: textFieldController)
    searchDebugViewController = SearchDebugViewController(filterState: controller.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)
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
  
  func setupUI() {
    view.backgroundColor = .white
    let tableView = facetListController.tableView
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchDebugViewController.view.translatesAutoresizingMaskIntoConstraints = false
    searchDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    let stackView = UIStackView()
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    stackView.pin(to: view)
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(searchDebugViewController.view)
    stackView.addArrangedSubview(tableView)
  }

}

