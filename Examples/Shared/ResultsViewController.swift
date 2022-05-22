//
//  ResultsViewController.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import UIKit
import InstantSearch
import SDWebImage

class ResultsViewController: UIViewController {

  let stackView: UIStackView
  let hitsViewController: StoreItemsTableViewController

  let statsConnector: StatsConnector
  let statsController: LabelStatsController

  let loadingConnector: LoadingConnector
  let loadingController: ActivityIndicatorController

  init(searcher: HitsSearcher) {
    stackView = .init(frame: .zero)
    hitsViewController = .init(style: .plain)
    statsController = .init(label: .init())
    statsConnector = .init(searcher: searcher, controller: statsController)
    loadingController = .init(activityIndicator: .init())
    loadingConnector = .init(searcher: searcher, controller: loadingController)
    super.init(nibName: nil, bundle: nil)
    addChild(hitsViewController)
    hitsViewController.didMove(toParent: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    statsController.label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    loadingController.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingController.activityIndicator.hidesWhenStopped = true
    let detailsStackView = UIStackView()
    detailsStackView.translatesAutoresizingMaskIntoConstraints = false
    detailsStackView.axis = .horizontal
    detailsStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    detailsStackView.isLayoutMarginsRelativeArrangement = true
    detailsStackView.addArrangedSubview(statsController.label)
    detailsStackView.addArrangedSubview(.spacer)
    detailsStackView.addArrangedSubview(loadingController.activityIndicator)
    stackView.addArrangedSubview(detailsStackView)
    stackView.addArrangedSubview(hitsViewController.view)
  }

}
