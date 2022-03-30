//
//  RefinementPersistentListDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 19/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class RefinementPersistentListDemoViewController: UIViewController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  
  let colorConnector: FacetListConnector
  let categoryConnector: FacetListConnector

  let searchStateViewController: SearchStateViewController
  let colorListController: FacetListTableController
  let categoryListController: FacetListTableController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = .init(client: .demo, indexName: "mobile_demo_facet_list")
    filterState = .init()
    colorConnector = .init(searcher: searcher, filterState: filterState, attribute: "color", selectionMode: .multiple, persistentSelection: true, operator: .or)
    categoryConnector = .init(searcher: searcher, filterState: filterState, attribute: "category", selectionMode: .single, persistentSelection: true, operator: .or)
    colorListController = .init(tableView: .init(), titleDescriptor: .init(text: "Multiple choice", color: .red))
    categoryListController = .init(tableView: .init(), titleDescriptor: .init(text: "Single choice", color: .blue))
    searchStateViewController = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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

private extension RefinementPersistentListDemoViewController {

  func setup() {
    searcher.connectFilterState(filterState)
    
    colorConnector.interactor.connectController(colorListController)
    categoryConnector.interactor.connectController(categoryListController)
    
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)

    searcher.search()
  }
  
  func setupLayout() {
    
    view.backgroundColor = .swBackground
    
    let mainStackView = UIStackView(frame: .zero)
    mainStackView.axis = .vertical
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.distribution = .fill
    mainStackView.spacing = .px16
    
    let listsStackView = UIStackView(frame: .zero)
    listsStackView.translatesAutoresizingMaskIntoConstraints = false
    listsStackView.axis = .horizontal
    listsStackView.distribution = .fillEqually
    listsStackView.spacing = .px16
    listsStackView.addArrangedSubview(colorListController.tableView)
    listsStackView.addArrangedSubview(categoryListController.tableView)
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(listsStackView)
    
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
      $0.backgroundColor = UIColor(hexString: "#f7f8fa")
    }
    
  }
  
}
