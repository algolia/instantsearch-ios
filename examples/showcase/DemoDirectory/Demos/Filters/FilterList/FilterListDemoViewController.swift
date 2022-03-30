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
  let searchStateViewController: SearchStateViewController
  
  init(items: [F], selectionMode: SelectionMode) {
    filterListController = FilterListTableController(tableView: .init())
    searchStateViewController = SearchStateViewController()
    controller = .init(filters: items,
                       controller: filterListController,
                       selectionMode: selectionMode)
    super.init(nibName: nil, bundle: nil)
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

private extension FilterListDemoViewController {
  
  func setup() {
    searchStateViewController.connectFilterState(controller.filterState)
    searchStateViewController.connectSearcher(controller.searcher)
  }
  
  func setupUI() {
    
    view.backgroundColor = .white
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(filterListController.tableView)
    
  }
  
}
