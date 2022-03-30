//
//  RatingViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/11/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class RatingViewController: UIViewController {
  
  let valueLabel: UILabel
  let stepper: UIStepper
  let numberInteractor: NumberInteractor<Double>
  let ratingController: NumericRatingController
  let filterState: FilterState
  let searchStateViewController: SearchStateViewController
  
  var ratingControl: RatingControl {
    return ratingController.ratingControl
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    valueLabel = UILabel()
    stepper = UIStepper()
    numberInteractor = NumberInteractor<Double>()
    ratingController = NumericRatingController()
    filterState = FilterState()
    searchStateViewController = SearchStateViewController()
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
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)

    searchStateViewController.connectFilterState(filterState)
    numberInteractor.connectNumberController(ratingController)
    numberInteractor.connectFilterState(filterState,
                                        attribute: "rating",
                                        numericOperator: .greaterThanOrEqual)
  }
  
  func setupLayout() {
    view.backgroundColor = .white
    
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
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
    
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    mainStackView.addArrangedSubview(searchStateViewController.view)
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
