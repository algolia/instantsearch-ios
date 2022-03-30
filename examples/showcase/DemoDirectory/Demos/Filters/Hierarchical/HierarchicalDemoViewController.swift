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
  let searchStateViewController: SearchStateViewController

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
    view.backgroundColor = . white
    let tableView = tableViewController.view!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
    
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(tableView)
  }

}

