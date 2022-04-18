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
  let searchDebugViewController: SearchDebugViewController

  let tableView: UITableView
  let searchTextField: UISearchTextField

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = CurrentFiltersDemoController()
    searchDebugViewController = .init(filterState: demoController.filterState)

    tableView = .init()
    searchTextField = .init()

    currentFiltersController = .init(tableView: tableView)
    currentFiltersController2 = .init(searchTextField: searchTextField)
    demoController.currentFiltersListConnector.connectController(currentFiltersController)
    demoController.currentFiltersListConnector.connectController(currentFiltersController2)

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
}

private extension CurrentFiltersDemoViewController {

  func setupUI() {

    view.backgroundColor = .white

    let mainStackView = UIStackView()
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10

    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
    
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)
    searchDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    let searchTextFieldContainer = UIView()
    searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
    searchTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    searchTextFieldContainer.addSubview(searchTextField)
    searchTextField.pin(to: searchTextFieldContainer, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
    mainStackView.addArrangedSubview(searchDebugViewController.view)
    mainStackView.addArrangedSubview(searchTextFieldContainer)
    mainStackView.addArrangedSubview(tableView)
    
  }

}

