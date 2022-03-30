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

  let genderAttribute = Attribute("gender")
  
  let searcher: HitsSearcher
  let filterState: FilterState

  let genderInteractor: SelectableSegmentInteractor<Int, Filter.Facet>
  let segmentedController: SegmentedController<Filter.Facet>
  let searchStateViewController: SearchStateViewController

  let mainStackView = UIStackView(frame: .zero)
  
  let male = Filter.Facet(attribute: "gender", stringValue: "male")
  let female = Filter.Facet(attribute: "gender", stringValue: "female")
  let notSpecified = Filter.Facet(attribute: "gender", stringValue: "not specified")
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_filter_segment")
    let items: [Int: Filter.Facet] = [
      0: male,
      1: female,
      2: notSpecified,
    ]
    self.filterState = FilterState()
    self.genderInteractor = SelectableSegmentInteractor(items: items)
    self.searchStateViewController = SearchStateViewController()
    segmentedController = SegmentedController<Filter.Facet>(segmentedControl: .init())
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
    
    searcher.search()
    searcher.connectFilterState(filterState)

    genderInteractor.connectSearcher(searcher, attribute: genderAttribute)
    genderInteractor.connectFilterState(filterState, attribute: genderAttribute, operator: .or)
    genderInteractor.connectController(segmentedController)
    
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    
    filterState.notify(.add(filter: male, toGroupWithID: .or(name: genderAttribute.rawValue, filterType: .facet)))
    
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

    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
    mainStackView.addArrangedSubview(spacerView)
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .center
  }
  
}
