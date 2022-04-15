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
  let searchStateViewController: SearchDebugViewController

  let tableView: UITableView
  let searchTextField: UISearchTextField

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = CurrentFiltersDemoController()
    searchStateViewController = .init()

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
    searchStateViewController.connectFilterState(demoController.filterState)
    setupUI()
  }
  
}

private extension CurrentFiltersDemoViewController {

  func setupUI() {

    view.backgroundColor = .white

    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 16

    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    let searchTextFieldContainer = UIView()
    searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
    searchTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    searchTextFieldContainer.addSubview(searchTextField)
    searchTextField.pin(to: searchTextFieldContainer, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(searchTextFieldContainer)
    mainStackView.addArrangedSubview(tableView)
    
  }

}

