//
//  FacetListPersistentDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 19/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FacetListPersistentDemoViewController: UIViewController {
  
  let demoController: FacetListPersistentSelectionDemoController
  let searchStateViewController: SearchDebugViewController
  let colorListController: FacetListTableController
  let categoryListController: FacetListTableController

  init() {
    demoController = .init()
    colorListController = .init(tableView: .init(),
                                titleDescriptor: .init(text: "Multiple choice", color: .red))
    categoryListController = .init(tableView: .init(),
                                   titleDescriptor: .init(text: "Single choice", color: .blue))
    searchStateViewController = .init()
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }
  
}

private extension FacetListPersistentDemoViewController {

  func setup() {
    demoController.colorConnector.interactor.connectController(colorListController)
    demoController.categoryConnector.interactor.connectController(categoryListController)
    searchStateViewController.connectSearcher(demoController.searcher)
    searchStateViewController.connectFilterState(demoController.filterState)
  }
  
  func setupLayout() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView(frame: .zero)
    mainStackView.axis = .vertical
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.distribution = .fill
    mainStackView.spacing = 16
    
    let listsStackView = UIStackView(frame: .zero)
    listsStackView.translatesAutoresizingMaskIntoConstraints = false
    listsStackView.axis = .horizontal
    listsStackView.distribution = .fillEqually
    listsStackView.spacing = 16
    listsStackView.addArrangedSubview(colorListController.tableView)
    listsStackView.addArrangedSubview(categoryListController.tableView)
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(listsStackView)
    mainStackView.addArrangedSubview(.spacer)
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)

    [
      colorListController,
      categoryListController
    ]
      .map { $0.tableView }
      .forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
      $0.alwaysBounceVertical = false
      $0.tableFooterView = UIView(frame: .zero)
    }
    
  }
  
}
