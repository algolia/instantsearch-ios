//
//  ToggleFilterDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class ToggleFilterDemoViewController: UIViewController {

  let demoController: ToggleFilterDemoController

  let mainStackView = UIStackView()
  let controlsStackView = UIStackView()
  let couponStackView = UIStackView()

  let vintageButtonController: SelectableFilterButtonController<Filter.Tag>
  let sizeConstraintButtonController: SelectableFilterButtonController<Filter.Numeric>
  let couponSwitchController: FilterSwitchController<Filter.Facet>

  let filterDebugViewController: FilterDebugViewController

  let couponLabel = UILabel()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    sizeConstraintButtonController = SelectableFilterButtonController(button: .init())
    vintageButtonController = SelectableFilterButtonController(button: .init())
    couponSwitchController = FilterSwitchController(switch: .init())
    demoController = .init()
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

private extension ToggleFilterDemoViewController {

  func setup() {
    demoController.clearFilterConnector.connectController(filterDebugViewController.clearFilterController)
    demoController.sizeConstraintConnector.connectController(sizeConstraintButtonController)
    demoController.vintageConnector.connectController(vintageButtonController)
    demoController.couponConnector.connectController(couponSwitchController)
  }

  func setupUI() {
    view.backgroundColor = .systemBackground
    configureSizeButton()
    configureVintageButton()
    configureCouponLabel()
    configureCouponSwitch()
    configureCouponStackView()
    configureMainStackView()
    configureControlsStackView()
    configureLayout()
  }

  func configureLayout() {

    view.addSubview(mainStackView)

    mainStackView.pin(to: view)

    addChild(filterDebugViewController)
    filterDebugViewController.didMove(toParent: self)
    filterDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    mainStackView.addArrangedSubview(filterDebugViewController.view)

    couponStackView.addArrangedSubview(couponLabel)
    couponStackView.addArrangedSubview(couponSwitchController.switch)

    controlsStackView.addArrangedSubview(spacer())
    controlsStackView.addArrangedSubview(sizeConstraintButtonController.button)
    controlsStackView.addArrangedSubview(spacer())
    controlsStackView.addArrangedSubview(vintageButtonController.button)
    controlsStackView.addArrangedSubview(spacer())
    controlsStackView.addArrangedSubview(couponStackView)
    controlsStackView.addArrangedSubview(spacer())
    mainStackView.addArrangedSubview(controlsStackView)
    mainStackView.addArrangedSubview(spacer())
  }

  private func spacer() -> UIView {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return view
  }

  func configureMainStackView() {
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureControlsStackView() {
    controlsStackView.axis = .horizontal
    controlsStackView.distribution = .equalSpacing
    controlsStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureCouponStackView() {
    couponStackView.translatesAutoresizingMaskIntoConstraints = false
    couponStackView.axis = .horizontal
    couponStackView.spacing = 16
    couponStackView.alignment = .center
    couponStackView.distribution = .fill
  }

  func configureSizeButton() {
    let button = sizeConstraintButtonController.button
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("size > 40", for: .normal)
    button.setTitleColor(.systemGray, for: .normal)
    button.setTitleColor(UIColor.tintColor, for: .selected)
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 10
    button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    button.addTarget(self, action: #selector(didTapSizeButton), for: .touchUpInside)
  }

  @objc func didTapSizeButton(_ button: UIButton) {
    let borderColor: UIColor =  button.isSelected ? .systemGray : UIColor.tintColor
    button.layer.borderColor = borderColor.cgColor
  }

  func configureVintageButton() {
    let button = vintageButtonController.button
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("vintage", for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.setTitleColor(.black, for: .normal)
    button.setImage(UIImage(systemName: "square"), for: .normal)
    button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
  }

  func configureCouponSwitch() {
    couponSwitchController.switch.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureCouponLabel() {
    couponLabel.text = "Coupon"
    couponLabel.translatesAutoresizingMaskIntoConstraints = false
  }

}
