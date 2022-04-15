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
  let searchStateViewController: SearchDebugViewController

  let tableViewController: UITableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    tableViewController = .init(style: .plain)
    hierarchicalTableViewController = .init(tableView: tableViewController.tableView)
    searchStateViewController = .init()
    demoController = .init(controller: hierarchicalTableViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(tableViewController)
    tableViewController.didMove(toParent: self)
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
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.connectFilterState(demoController.filterState)
  }
  
  private func setupUI() {
    title = "Hierarchical Facets"
    view.backgroundColor = . white
    let tableView = tableViewController.view!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide, insets: .init(top: 0, left: 10, bottom: 0, right: -10))    
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(tableView)
  }

}

