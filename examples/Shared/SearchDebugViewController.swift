//
//  SearchDebugViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchCore

class SearchDebugViewController: UIViewController {
    
  let mainStackView: UIStackView
  let titleLabel: UILabel
  let filterStateViewController: FiltersDebugViewController
  
  init(filterState: FilterState) {
    self.mainStackView = UIStackView()
    self.titleLabel = UILabel()
    self.filterStateViewController = FiltersDebugViewController()
    super.init(nibName: nil, bundle: nil)
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
    configureMainStackView()
    configureTitleLabel()
    configureFilterStateViewController()
    configureLayout()
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = 4
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .top
  }
  
  func configureTitleLabel() {
    titleLabel.font = .boldSystemFont(ofSize: 25)
    titleLabel.text = "Filters"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureFilterStateViewController() {
    filterStateViewController.colorMap = [
      "_tags": UIColor(hexString: "#9673b4"),
      "size": UIColor(hexString: "#698c28"),
      "color": .red,
      "promotions": .blue,
      "category": .green
    ]
  }
  
  func configureLayout() {
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(filterStateViewController.stateLabel)
    mainStackView.addArrangedSubview(.spacer)
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.layer.borderWidth = 0.5
    containerView.layer.borderColor = UIColor.black.cgColor
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 10
    containerView.addSubview(mainStackView)
    mainStackView.pin(to: containerView, insets: .init(top: 10, left: 10, bottom: -10, right: -10))
    view.addSubview(containerView)
    containerView.pin(to: view)
  }
  
}
