//
//  StatsDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class StatsDemoViewController: UIViewController {
  
  let stackView = UIStackView()
  let searchBar = UISearchBar()
  let controller: StatsDemoController
  
  let textFieldController: TextFieldController
  
  let labelStatsController: LabelStatsController
  let attributedLabelStatsController: AttributedLabelStatsController
  
  init() {
    self.textFieldController = .init(searchBar: searchBar)
    self.attributedLabelStatsController = AttributedLabelStatsController(label: .init())
    self.labelStatsController = LabelStatsController(label: .init())
    self.controller = .init(queryInputController: textFieldController,
                            statsController: labelStatsController,
                            attributedStatsController: attributedLabelStatsController)
    super.init(nibName: .none, bundle: .none)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
}

private extension StatsDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    stackView.addArrangedSubview(searchBar)
    let statsMSContainer = UIView()
    statsMSContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
    statsMSContainer.translatesAutoresizingMaskIntoConstraints = false
    statsMSContainer.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
    labelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
    statsMSContainer.addSubview(labelStatsController.label)
    labelStatsController.label.pin(to: statsMSContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsMSContainer)
    
    let attributedStatsContainer = UIView()
    attributedStatsContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
    attributedStatsContainer.translatesAutoresizingMaskIntoConstraints = false
    attributedStatsContainer.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
    attributedLabelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
    attributedStatsContainer.addSubview(attributedLabelStatsController.label)
    attributedLabelStatsController.label.pin(to: attributedStatsContainer.layoutMarginsGuide)
    
    stackView.addArrangedSubview(attributedStatsContainer)
    stackView.addArrangedSubview(UIView())
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
  }
  
}

