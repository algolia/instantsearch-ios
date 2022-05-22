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

  let searchController: UISearchController
  let controller: StatsDemoController

  let textFieldController: TextFieldController
  let resultsViewController: ResultsViewController

  init() {
    self.resultsViewController = ResultsViewController()
    self.searchController = .init(searchResultsController: resultsViewController)
    self.textFieldController = .init(searchBar: searchController.searchBar)
    self.controller = .init()
    super.init(nibName: .none, bundle: .none)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    controller.searchBoxConnector.connectController(textFieldController)
    controller.statsConnector.connectController(resultsViewController.labelStatsController) { stats -> String? in
      guard let stats = stats else {
        return nil
      }
      return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
    }
    controller.statsConnector.connectController(resultsViewController.attributedLabelStatsController) { stats -> NSAttributedString? in
      guard let stats = stats else {
        return nil
      }
      let string = NSMutableAttributedString()
      string.append(NSAttributedString(string: "\(stats.totalHitsCount)", attributes: [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 15)!]))
      string.append(NSAttributedString(string: "  hits"))
      return string
    }
    setupUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    definesPresentationContext = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }

  class ResultsViewController: UIViewController {

    let stackView: UIStackView
    let labelStatsController: LabelStatsController
    let attributedLabelStatsController: AttributedLabelStatsController

    init() {
      stackView = UIStackView()
      attributedLabelStatsController = AttributedLabelStatsController(label: .init())
      labelStatsController = LabelStatsController(label: .init())
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
    }

    private func configureUI() {
      title = "Stats"
      view.backgroundColor = .systemBackground
      stackView.spacing = 16
      stackView.alignment = .center
      stackView.axis = .vertical
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.isLayoutMarginsRelativeArrangement = true
      stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
      labelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(labelStatsController.label)
      attributedLabelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(attributedLabelStatsController.label)
      stackView.addArrangedSubview(.spacer)
      view.addSubview(stackView)
      stackView.pin(to: view.safeAreaLayoutGuide)
    }

  }

}
