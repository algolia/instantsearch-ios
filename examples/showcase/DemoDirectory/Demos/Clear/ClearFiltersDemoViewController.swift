//
//  ClearFiltersDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class ClearFiltersDemoViewController: UIViewController {

  let controller: ClearFiltersDemoController
  
  let searchStateViewController: SearchStateViewController

  let clearColorsController: FilterClearButtonController
  let clearExceptColorsController: FilterClearButtonController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    searchStateViewController = .init()

    clearColorsController = .init(button: .init())
    clearExceptColorsController = .init(button: .init())
    controller = .init(clearController: clearColorsController,
                       clearExceptController: clearExceptColorsController)

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

  func setup() {
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.connectFilterState(controller.filterState)
  }

  func setupUI() {
    view.backgroundColor = .white
    configureButton(clearColorsController.button, text: "Clear Colors")
    configureButton(clearExceptColorsController.button, text: "Clear Except Colors")
    configureLayout()
  }

  func configureButton(_ button: UIButton, text: String) {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.layer.cornerRadius = 10
  }

  func configureLayout() {

    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = 16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    mainStackView.addArrangedSubview(searchStateViewController.view)

    NSLayoutConstraint.activate([
      searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150),
      searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.98)
    ])

    let buttonsStackView = UIStackView()
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
    buttonsStackView.axis = .horizontal
    buttonsStackView.spacing = 16
    buttonsStackView.distribution = .equalCentering

    buttonsStackView.addArrangedSubview(clearColorsController.button)
    buttonsStackView.addArrangedSubview(clearExceptColorsController.button)
    
    mainStackView.addArrangedSubview(buttonsStackView)
    mainStackView.addArrangedSubview(.init())
    
    view.addSubview(mainStackView)
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])

  }

}
