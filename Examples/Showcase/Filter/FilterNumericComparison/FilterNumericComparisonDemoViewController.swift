//
//  FilterNumericComparisonDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable type_name

import Foundation
import UIKit
import InstantSearch

class FilterNumericComparisonDemoViewController: UIViewController {

  let demoController: FilterNumericComparisonDemoController
  let yearTextFieldController: NumericTextFieldController
  let numericStepperController: NumericStepperController
  let priceStepperValueLabel = UILabel()
  let filterDebugViewController: FilterDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = .init()
    yearTextFieldController = NumericTextFieldController()
    numericStepperController = NumericStepperController()
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
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
    demoController.priceConnector.connectNumberController(numericStepperController)
    demoController.yearConnector.connectNumberController(yearTextFieldController)
    priceStepperValueLabel.text = demoController.priceConnector.interactor.item.flatMap { "\($0)" }
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
  }

  func setupUI() {

    view.backgroundColor = .systemBackground

    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)

    let searchDebugView = filterDebugViewController.view!
    searchDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    searchDebugView.translatesAutoresizingMaskIntoConstraints = false

    let mainStackView = UIStackView()
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.addArrangedSubview(searchDebugView)
    mainStackView.addArrangedSubview(makeYearInputStackView())
    mainStackView.addArrangedSubview(makePriceStackView())
    mainStackView.addArrangedSubview(.spacer)

    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
  }

  private func makeYearInputStackView() -> UIStackView {
    let yearInputLabel = UILabel()
    yearInputLabel.translatesAutoresizingMaskIntoConstraints = false
    yearInputLabel.text = "Year:"

    yearTextFieldController.textField.borderStyle = .roundedRect
    yearTextFieldController.textField.textAlignment = .right
    yearTextFieldController.textField.translatesAutoresizingMaskIntoConstraints = false
    yearTextFieldController.textField.keyboardType = .numberPad

    let yearInputStackView = UIStackView()
    yearInputStackView.spacing = 10
    yearInputStackView.translatesAutoresizingMaskIntoConstraints = false
    yearInputStackView.axis = .horizontal
    yearInputStackView.addArrangedSubview(yearInputLabel)
    yearInputStackView.addArrangedSubview(.spacer)
    yearInputStackView.addArrangedSubview(yearTextFieldController.textField)
    return yearInputStackView
  }

  private func makePriceStackView() -> UIStackView {
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
    priceStepperStackView.spacing = 10
    priceStepperStackView.addArrangedSubview(priceStepperTitleLabel)
    priceStepperStackView.addArrangedSubview(.spacer)
    priceStepperStackView.addArrangedSubview(priceStepperValueLabel)
    priceStepperStackView.addArrangedSubview(numericStepperController.stepper)
    return priceStepperStackView
  }

  @objc func onStepperValueChanged(sender: UIStepper) {
    priceStepperValueLabel.text = demoController.priceConnector.interactor.item.flatMap { "\($0)" }
  }

}
