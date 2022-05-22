//
//  FilterListDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 26/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class FilterListDemoViewController<F: FilterType & Hashable>: UIViewController {

  let demoController: FilterListDemoController<F>

  let filterListController: FilterListTableController<F>
  let filterDebugViewController: FilterDebugViewController

  init(items: [F], selectionMode: SelectionMode) {
    filterListController = FilterListTableController(tableView: .init())
    demoController = .init(filters: items,
                           controller: filterListController,
                           selectionMode: selectionMode)
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
    super.init(nibName: nil, bundle: nil)
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension FilterListDemoViewController {

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

    mainStackView.addArrangedSubview(filterDebugViewController.view)
    mainStackView.addArrangedSubview(filterListController.tableView)
  }

}
