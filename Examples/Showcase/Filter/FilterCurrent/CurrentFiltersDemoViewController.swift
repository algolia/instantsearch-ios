//
//  CurrentFiltersDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class CurrentFiltersDemoViewController: UIViewController {

  let demoController: CurrentFiltersDemoController
  let currentFiltersController: CurrentFilterListTableController
  let currentFiltersController2: SearchTextFieldCurrentFiltersController
  let filterDebugViewController: FilterDebugViewController

  let tableView: UITableView
  let searchTextField: UISearchTextField

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = CurrentFiltersDemoController()
    filterDebugViewController = .init(filterState: demoController.filterState)
    tableView = .init()
    searchTextField = .init()
    currentFiltersController = .init(tableView: tableView)
    currentFiltersController2 = .init(searchTextField: searchTextField)
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

private extension CurrentFiltersDemoViewController {

  func setup() {
    demoController.currentFiltersListConnector.connectController(currentFiltersController)
    demoController.currentFiltersListConnector.connectController(currentFiltersController2)
    demoController.clearFiltersConnector.connectController(filterDebugViewController.clearFilterController)
  }

  func setupUI() {

    view.backgroundColor = .systemBackground

    let mainStackView = UIStackView()
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10

    view.addSubview(mainStackView)
    mainStackView.pin(to: view)

    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    filterDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    let searchTextFieldContainer = UIView()
    searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
    searchTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    searchTextFieldContainer.addSubview(searchTextField)
    searchTextField.pin(to: searchTextFieldContainer, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
    mainStackView.addArrangedSubview(filterDebugViewController.view)
    mainStackView.addArrangedSubview(searchTextFieldContainer)
    mainStackView.addArrangedSubview(tableView)

  }

}
