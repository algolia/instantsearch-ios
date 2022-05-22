//
//  SegmentedFilterDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SegmentedFilterDemoViewController: UIViewController {

  let demoController: SegmentedFilterDemoController
  let segmentedController: SegmentedController<Filter.Facet>
  let filterDebugViewController: FilterDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    segmentedController = SegmentedController<Filter.Facet>(segmentedControl: .init())
    demoController = .init()
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
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

private extension SegmentedFilterDemoViewController {

  func setup() {
    demoController.filterMapConnector.connectController(segmentedController)
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
    segmentedController.segmentedControl.selectedSegmentIndex = 0
  }

  func setupUI() {
    view.backgroundColor = .systemBackground

    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    filterDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    mainStackView.addArrangedSubview(filterDebugViewController.view)
    mainStackView.addArrangedSubview(segmentedController.segmentedControl)
    mainStackView.addArrangedSubview(.spacer)

    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
  }

}
