//
//  FilterNumericComparisonDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumericComparisonDemoViewController: UIViewController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  
  let yearConnector: FilterComparisonConnector<Int>
  let priceConnector: FilterComparisonConnector<Double>
  
  let searchStateViewController: SearchStateViewController
  
  let yearTextFieldController: NumericTextFieldController
  let numericStepperController: NumericStepperController
  
  let priceStepperValueLabel = UILabel()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()
    
    yearTextFieldController = NumericTextFieldController()
    numericStepperController = NumericStepperController()
    
    self.yearConnector = .init(searcher: searcher,
                               filterState: filterState,
                               attribute: "year",
                               numericOperator: .greaterThanOrEqual,
                               number: 0,
                               bounds: nil,
                               operator: .and,
                               controller: yearTextFieldController)
    
    self.priceConnector = .init(searcher: searcher,
                                filterState: filterState,
                                attribute: "price",
                                numericOperator: .greaterThanOrEqual,
                                number: 0,
                                bounds: nil,
                                operator: .and,
                                controller: numericStepperController)
    
    
    self.searchStateViewController = SearchStateViewController()
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

private extension FilterNumericComparisonDemoViewController {
  
  func setup() {
    searcher.connectFilterState(filterState)
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    searcher.search()
    priceStepperValueLabel.text = priceConnector.interactor.item.flatMap { "\($0)" }
  }
  
  func setupUI() {
    
    func spacer() -> UIView {
      let spacerView = UIView()
      spacerView.translatesAutoresizingMaskIntoConstraints = false
      return spacerView
    }
    
    view.backgroundColor = .white
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    let yearInputLabel = UILabel()
    yearInputLabel.translatesAutoresizingMaskIntoConstraints = false
    yearInputLabel.text = "Year:"
    
    yearTextFieldController.textField.borderStyle = .roundedRect
    yearTextFieldController.textField.textAlignment = .right
    yearTextFieldController.textField.translatesAutoresizingMaskIntoConstraints = false
    yearTextFieldController.textField.keyboardType = .numberPad
    
    let yearInputStackView = UIStackView()
    yearInputStackView.spacing = .px16
    yearInputStackView.translatesAutoresizingMaskIntoConstraints = false
    yearInputStackView.axis = .horizontal
    yearInputStackView.addArrangedSubview(yearInputLabel)
    yearInputStackView.addArrangedSubview(spacer())
    yearInputStackView.addArrangedSubview(yearTextFieldController.textField)
    
    
    let yearInputContainer = UIView()
    yearInputContainer.translatesAutoresizingMaskIntoConstraints = false
    yearInputContainer.addSubview(yearInputStackView)
    yearInputStackView.pin(to: yearInputContainer, insets: .init(top: 0, left: 8, bottom: 0, right: -8))
    
    let priceStepperTitleLabel = UILabel()
    priceStepperTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    priceStepperTitleLabel.text = "Price:"
    
    numericStepperController.stepper.translatesAutoresizingMaskIntoConstraints = false
    numericStepperController.stepper.addTarget(self, action: #selector(onStepperValueChanged), for: .valueChanged)
    
    priceStepperValueLabel.translatesAutoresizingMaskIntoConstraints = false
    priceStepperValueLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    
    let priceStepperStackView = UIStackView()
    priceStepperStackView.translatesAutoresizingMaskIntoConstraints = false
    priceStepperStackView.axis = .horizontal
    priceStepperStackView.spacing = 8
    priceStepperStackView.addArrangedSubview(priceStepperTitleLabel)
    priceStepperStackView.addArrangedSubview(spacer())
    priceStepperStackView.addArrangedSubview(priceStepperValueLabel)
    priceStepperStackView.addArrangedSubview(numericStepperController.stepper)
    
    let priceStepperContainer = UIView()
    priceStepperContainer.translatesAutoresizingMaskIntoConstraints = false
    priceStepperContainer.addSubview(priceStepperStackView)
    priceStepperStackView.pin(to: priceStepperContainer, insets: .init(top: 0, left: 8, bottom: 0, right: -8))
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .leading
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(yearInputContainer)
    mainStackView.addArrangedSubview(priceStepperContainer)
    mainStackView.addArrangedSubview(spacer())
    
    searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
    yearInputContainer.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
    priceStepperContainer.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  @objc func onStepperValueChanged(sender: UIStepper) {
    priceStepperValueLabel.text = priceConnector.interactor.item.flatMap { "\($0)" }
  }
  
}

extension UIView: Builder {}
