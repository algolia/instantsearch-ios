//
//  SegmentedDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SegmentedDemoViewController: UIViewController {
  
  let demoController: SegmentedFilterDemoController
  let segmentedController: SegmentedController<Filter.Facet>
  let searchDebugViewController: SearchDebugViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    segmentedController = SegmentedController<Filter.Facet>(segmentedControl: .init())
    demoController = .init(segmentedController: segmentedController)
    searchDebugViewController = SearchDebugViewController(filterState: demoController.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
}

private extension SegmentedDemoViewController {
    
  func setupUI() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)
    searchDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    mainStackView.addArrangedSubview(searchDebugViewController.view)
    mainStackView.addArrangedSubview(segmentedController.segmentedControl)
    mainStackView.addArrangedSubview(.spacer)
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
  }
  
}
