//
//  FilterDebugViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchCore

class FilterDebugViewController: UIViewController {

  let titleLabel: UILabel
  let filterStateViewController: FilterDebugController
  let clearFilterController: FilterClearButtonController

  init(filterState: FilterState) {
    self.titleLabel = UILabel()
    self.filterStateViewController = FilterDebugController()
    self.clearFilterController = .init(button: .init())
    super.init(nibName: nil, bundle: nil)
    configureFilterStateViewController()
    filterStateViewController.connectTo(filterState)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    configureTitleLabel()
    configureClearButton()
    configureLayout()
  }

  func configureTitleLabel() {
    titleLabel.font = .boldSystemFont(ofSize: 25)
    titleLabel.text = "Filters"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureClearButton() {
    clearFilterController.button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
    clearFilterController.button.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureFilterStateViewController() {
    filterStateViewController.colorMap = [
      "_tags": .systemIndigo,
      "size": .systemTeal,
      "color": .systemRed,
      "promotions": .systemBlue,
      "category": .systemGreen
    ]
  }

  func configureLayout() {
    let headerStackView = UIStackView()
    headerStackView.translatesAutoresizingMaskIntoConstraints = false
    headerStackView.axis = .horizontal
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(.spacer)
    headerStackView.addArrangedSubview(clearFilterController.button)

    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.addArrangedSubview(headerStackView)
    mainStackView.addArrangedSubview(filterStateViewController.stateLabel)
    mainStackView.addArrangedSubview(.spacer)

    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.layer.borderWidth = 0.5
    containerView.layer.borderColor = UIColor.black.cgColor
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 10
    containerView.addSubview(mainStackView)
    view.addSubview(containerView)

    mainStackView.pin(to: containerView, insets: .init(top: 10, left: 10, bottom: -10, right: -10))
    containerView.pin(to: view)
  }

}
