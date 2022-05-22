//
//  RelevantSortResultsViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 20/04/2022.
//

import Foundation
import UIKit
import InstantSearch

class RelevantSortResultsViewController: UIViewController {

  let hitsController: ProductsTableViewController
  let relevantSortController: RelevantSortToggleController
  let statsController: LabelStatsController

  init() {
    hitsController = .init()
    relevantSortController = .init()
    statsController = .init(label: .init())
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    let infoStackView = UIStackView()
    infoStackView.spacing = 5
    infoStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    infoStackView.isLayoutMarginsRelativeArrangement = true
    infoStackView.axis = .vertical
    infoStackView.translatesAutoresizingMaskIntoConstraints = false

    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    infoStackView.addArrangedSubview(statsController.label)

    relevantSortController.view.translatesAutoresizingMaskIntoConstraints = false
    infoStackView.addArrangedSubview(relevantSortController.view)

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    stackView.addArrangedSubview(infoStackView)
    stackView.addArrangedSubview(hitsController.view)
  }

}
