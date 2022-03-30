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
      .set(\.axis, to: .vertical)
      .set(\.alignment, to: .center)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .fill)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    
    mainStackView.addArrangedSubview(searchStateViewController.view)

    NSLayoutConstraint.activate([
      searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150),
      searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.98)
    ])

    let buttonsStackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .horizontal)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .equalCentering)

    buttonsStackView.addArrangedSubview(clearColorsController.button)
    buttonsStackView.addArrangedSubview(clearExceptColorsController.button)
    
    mainStackView.addArrangedSubview(buttonsStackView)
    mainStackView.addArrangedSubview(.init())
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)

  }

}
