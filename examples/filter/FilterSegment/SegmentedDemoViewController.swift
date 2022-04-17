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
  let searchStateViewController: SearchDebugViewController

  let mainStackView = UIStackView(frame: .zero)
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searchStateViewController = SearchDebugViewController()
    segmentedController = SegmentedController<Filter.Facet>(segmentedControl: .init())
    self.demoController = .init(segmentedController: segmentedController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
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
  
  func setup() {
    searchStateViewController.connectSearcher(demoController.searcher)
    searchStateViewController.connectFilterState(demoController.filterState)
  }
  
  func setupUI() {
    view.backgroundColor = .white
    configureMainStackView()
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    mainStackView.addArrangedSubview(searchStateViewController.view)
    searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1).isActive = true

    segmentedController.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    mainStackView.addArrangedSubview(segmentedController.segmentedControl)
    segmentedController.segmentedControl.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9).isActive = true

    mainStackView.addArrangedSubview(.spacer)
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = 16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .center
  }
  
}
