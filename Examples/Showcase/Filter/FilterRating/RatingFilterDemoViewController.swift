//
//  RatingFilterDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/11/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class RatingFilterDemoViewController: UIViewController {

  let demoController: RatingFilterDemoController
  let valueLabel: UILabel
  let stepper: UIStepper
  let ratingController: NumericRatingController
  let filterDebugViewController: FilterDebugViewController

  var ratingControl: RatingControl {
    return ratingController.ratingControl
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoController = .init()
    valueLabel = UILabel()
    stepper = UIStepper()
    ratingController = NumericRatingController()
    filterDebugViewController = FilterDebugViewController(filterState: demoController.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setup()
  }

  private func setup() {
    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    demoController.numberInteractor.connectNumberController(ratingController)
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
  }

  func setupLayout() {
    view.backgroundColor = .systemBackground

    let mainStackView = UIStackView()
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    view.addSubview(mainStackView)
    mainStackView.pin(to: view)

    let searchDebugView = filterDebugViewController.view!
    searchDebugView.translatesAutoresizingMaskIntoConstraints = false
    searchDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchDebugView)

    ratingControl.translatesAutoresizingMaskIntoConstraints = false
    ratingControl.value = 3.5
    ratingControl.maximumValue = 5
    ratingControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
    ratingControl.tintColor = .systemGreen

    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.value = 3.5
    stepper.minimumValue = 0
    stepper.maximumValue = 5
    stepper.stepValue = 0.1
    stepper.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)

    valueLabel.font = .systemFont(ofSize: 20, weight: .heavy)
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    valueLabel.widthAnchor.constraint(equalToConstant: 44).isActive = true
    refreshLabel()

    let ratingStackView = UIStackView()
    ratingStackView.spacing = 10
    ratingStackView.translatesAutoresizingMaskIntoConstraints = false
    ratingStackView.distribution = .fill
    ratingStackView.alignment = .top
    ratingStackView.addArrangedSubview(ratingControl)
    ratingStackView.addArrangedSubview(valueLabel)
    ratingStackView.addArrangedSubview(stepper)
    mainStackView.addArrangedSubview(ratingStackView)
  }

  @objc private func controlValueChanged(_ sender: Any) {
    switch sender as? UIControl {
    case stepper:
      ratingControl.value = stepper.value
    case ratingControl:
      stepper.value = ratingControl.value
    default:
      break
    }
    refreshLabel()
  }

  private func refreshLabel() {
    valueLabel.text = fractionalString(for: ratingControl.value, fractionDigits: 1)
  }

  private func fractionalString(for value: Double, fractionDigits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = fractionDigits
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: value as NSNumber) ?? "\(self)"
  }

}
