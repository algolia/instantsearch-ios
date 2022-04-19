//
//  RelevantSortDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class RelevantSortDemoViewController: UIViewController {
  
  let searchBar: UISearchBar
  let demoController: RelevantSortDemoController
  let hitsController: ProductsTableViewController
  let textFieldController: TextFieldController
  let relevantSortController: RelevantSortToggleController
  let sortByController: SortByController
  let statsController: LabelStatsController
  
  init() {
    self.searchBar = UISearchBar()
    self.hitsController = .init()
    self.textFieldController = .init(searchBar: searchBar)
    self.relevantSortController = .init()
    self.sortByController = .init(searchBar: searchBar)
    self.statsController = .init(label: .init())
    self.demoController = .init()
    super.init(nibName: nil, bundle: nil)
    demoController.sortByConnector.connectController(sortByController)  { indexName in
      switch indexName {
      case "test_Bestbuy":
        return "Most relevant"
      case "test_Bestbuy_vr_price_asc":
        return "Relevant Sort - Lowest Price"
      case "test_Bestbuy_replica_price_asc":
        return "Hard Sort - Lowest Price"
      default:
        return indexName.rawValue
      }
    }
    demoController.relevantSortConnector.connectController(relevantSortController)
    demoController.hitsConnector.connectController(hitsController)
    demoController.queryInputConnector.connectController(textFieldController)
    demoController.statsConnector.connectController(statsController)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    searchBar.showsScopeBar = true
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    stackView.addArrangedSubview(searchBar)
    let infoStackView = UIStackView()
    infoStackView.spacing = 5
    infoStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    infoStackView.isLayoutMarginsRelativeArrangement = true
    infoStackView.axis = .vertical
    infoStackView.translatesAutoresizingMaskIntoConstraints = false
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    relevantSortController.view.translatesAutoresizingMaskIntoConstraints = false
    infoStackView.addArrangedSubview(statsController.label)
    infoStackView.addArrangedSubview(relevantSortController.view)
    stackView.addArrangedSubview(infoStackView)
    stackView.addArrangedSubview(hitsController.view)
  }
  
}
