//
//  HierarchicalDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 08/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class HierarchicalDemoViewController: UIViewController {

  let demoController: HierarchicalDemoController

  let hierarchicalTableViewController: HierarchicalTableViewController
  let filterDebugViewController: FilterDebugViewController

  let tableViewController: UITableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    tableViewController = .init(style: .plain)
    hierarchicalTableViewController = .init(tableView: tableViewController.tableView)
    demoController = .init(controller: hierarchicalTableViewController)
    filterDebugViewController = .init(filterState: demoController.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setup()
  }

  private func setup() {
    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)

    addChild(tableViewController)
    tableViewController.didMove(toParent: self)

    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
  }

  private func setupUI() {
    title = "Hierarchical Facets"
    view.backgroundColor = . white

    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)

    let searchDebugView = filterDebugViewController.view!
    searchDebugView.translatesAutoresizingMaskIntoConstraints = false
    searchDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(filterDebugViewController.view)

    let tableView = tableViewController.view!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.addArrangedSubview(tableView)

    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
  }

}
