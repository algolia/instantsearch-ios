//
//  FilterNumericRangeDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumericRangeDemoViewController: UIViewController {

  let searchController: UISearchController
  let demoController: FilterNumericRangeDemoController
  let statsController: LabelStatsController
  let numericRangeController: NumericRangeController
  let filterDebugViewController: FilterDebugViewController
  let searchBoxController: TextFieldController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchController = UISearchController()
    demoController = .init()
    numericRangeController = NumericRangeController(rangeSlider: .init())
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
    statsController = LabelStatsController()
    searchBoxController = TextFieldController(searchBar: searchController.searchBar)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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

private extension FilterNumericRangeDemoViewController {

  func setup() {
    navigationItem.searchController = searchController
    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    demoController.searchBoxConnector.connectController(searchBoxController)
    demoController.statsConnector.connectController(statsController)
    demoController.rangeConnector.connectController(numericRangeController)
    demoController.rangeConnector.interactor.connectSearcher(demoController.searcher, attribute: "price")
    demoController.filterClearConnector.connectController(filterDebugViewController.clearFilterController)
  }

  func setupUI() {
    view.backgroundColor = .systemBackground
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    let searchDebugView = filterDebugViewController.view!
    searchDebugView.translatesAutoresizingMaskIntoConstraints = false
    searchDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchDebugView)
    mainStackView.addArrangedSubview(statsController.label)
    mainStackView.addArrangedSubview(numericRangeController.view)
    mainStackView.addArrangedSubview(.spacer)
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }

}
