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

  let searchController: UISearchController
  let demoController: DynamicFacetListDemoController

  let textFieldController: TextFieldController
  let facetsTableViewController: DynamicFacetListTableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    facetsTableViewController = .init()
    searchController = .init(searchResultsController: facetsTableViewController)
    textFieldController = TextFieldController(textField: searchController.searchBar.searchTextField)
    demoController = .init(searchBoxController: textFieldController,
                           dynamicFacetListController: facetsTableViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  private func setupUI() {
    title = "Dynamic Facets"
    view.backgroundColor = .systemBackground
    navigationItem.searchController = searchController
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(presentHint))
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }

  @objc private func presentHint() {
    let hintController = UIAlertController(title: "Help", message: DynamicFacetListDemoController.helpMessage, preferredStyle: .alert)
    hintController.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(hintController, animated: true)
  }

}
