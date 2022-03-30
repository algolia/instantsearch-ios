//
//  DynamicFacetListDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class DynamicFacetListDemoViewController: UIViewController {
  
  let demoController: DynamicFacetListDemoController
  
  let textFieldController: TextFieldController
  let facetsTableViewController: DynamicFacetListTableViewController
  
  let searchBar: UISearchTextField
  let hintLabel: UILabel
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    textFieldController = TextFieldController(textField: searchBar)
    facetsTableViewController = .init()
    demoController = .init(queryInputController: textFieldController,
                           DynamicFacetListController: facetsTableViewController)
    hintLabel = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    addChild(facetsTableViewController)
    facetsTableViewController.didMove(toParent: self)
    super.viewDidLoad()
    setupUI()
    demoController.searcher.onResults.subscribe(with: self) { (controller, searchResponse) in
      let isEmptyFacetOrder = searchResponse.renderingContent?.facetOrdering?.values.isEmpty ?? true
      controller.hintLabel.isHidden = !isEmptyFacetOrder
      controller.facetsTableViewController.view.isHidden = isEmptyFacetOrder
    }.onQueue(.main)
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    hintLabel.translatesAutoresizingMaskIntoConstraints = false
    hintLabel.textAlignment = .center
    hintLabel.text = "Type \"a\", \"ab\" or \"abc\" to trigger a rule"
    
    facetsTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.setContentHuggingPriority(.defaultHigh, for: .vertical)

    let searchBarContainer = UIView()
    searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
    searchBarContainer.addSubview(searchBar)
    searchBar.pin(to: searchBarContainer, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(searchBarContainer)
    stackView.addArrangedSubview(facetsTableViewController.view)
    stackView.addArrangedSubview(hintLabel)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
}
