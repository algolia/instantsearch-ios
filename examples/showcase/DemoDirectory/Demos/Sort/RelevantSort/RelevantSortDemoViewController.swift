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
  let controller: RelevantSortDemoController
  let hitsController: RelevantHitsController
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
    self.controller = .init(sortByController: sortByController,
                            relevantSortController: relevantSortController,
                            hitsController: hitsController,
                            queryInputController: textFieldController,
                            statsController: statsController)
    super.init(nibName: nil, bundle: nil)
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
    stackView.addArrangedSubview(statsController.label)
    stackView.addArrangedSubview(relevantSortController.view)
    stackView.addArrangedSubview(hitsController.view)
  }
  
}

class RelevantHitsController: UITableViewController, HitsController {
  
  var hitsSource: HitsInteractor<RelevantSortDemoController.Item>?
  
  let cellID = "cellID"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.textLabel?.text = hitsSource?.hit(atIndex: indexPath.row)?.name
    return cell
  }
  
}
