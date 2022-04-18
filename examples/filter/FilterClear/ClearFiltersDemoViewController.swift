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
  
  let searchDebugViewController: SearchDebugViewController

  let clearColorsController: FilterClearButtonController
  let clearExceptColorsController: FilterClearButtonController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    clearColorsController = .init(button: .init())
    clearExceptColorsController = .init(button: .init())
    controller = .init(clearController: clearColorsController,
                       clearExceptController: clearExceptColorsController)
    searchDebugViewController = .init(filterState: controller.filterState)
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
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)
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
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.spacing = 10
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    mainStackView.addArrangedSubview(searchDebugViewController.view)
    searchDebugViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    let buttonsStackView = UIStackView()
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
    buttonsStackView.axis = .horizontal
    buttonsStackView.distribution = .equalSpacing

    buttonsStackView.addArrangedSubview(clearColorsController.button)
    buttonsStackView.addArrangedSubview(clearExceptColorsController.button)
    
    mainStackView.addArrangedSubview(buttonsStackView)
    mainStackView.addArrangedSubview(.init())
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)

  }

}
