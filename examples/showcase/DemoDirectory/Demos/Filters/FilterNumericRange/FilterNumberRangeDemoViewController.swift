//
//  NumericRangeDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumberRangeDemoViewController: UIViewController {

  let controller: FilterNumberRangeDemoController

  let searchStateViewController: SearchDebugViewController
  
  let numericRangeController: NumericRangeController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    numericRangeController = NumericRangeController(rangeSlider: .init())
    
    self.controller = .init()
    self.searchStateViewController = SearchDebugViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    controller.rangeConnector.connectController(numericRangeController)
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searchStateViewController.connectSearcher(controller.searcher)
    searchStateViewController.connectFilterState(controller.filterState)
  }

}


private extension FilterNumberRangeDemoViewController {

  func setupUI() {
    view.backgroundColor = .white
    let searchStateView = searchStateViewController.view!
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .center
    mainStackView.addArrangedSubview(searchStateView)
    mainStackView.addArrangedSubview(numericRangeController.view)
    let spacer = UIView()
    spacer.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.addArrangedSubview(spacer)
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    searchStateView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    searchStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
  }

}
