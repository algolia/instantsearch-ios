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
  
  let controller: FilterListDemoController<F>

  let filterListController: FilterListTableController<F>
  let searchDebugViewController: SearchDebugViewController
  
  init(items: [F], selectionMode: SelectionMode) {
    filterListController = FilterListTableController(tableView: .init())
    controller = .init(filters: items,
                       controller: filterListController,
                       selectionMode: selectionMode)
    searchDebugViewController = SearchDebugViewController(filterState: controller.filterState)
    super.init(nibName: nil, bundle: nil)
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
    
    mainStackView.addArrangedSubview(searchDebugViewController.view)
    mainStackView.addArrangedSubview(filterListController.tableView)
  }
  
}
