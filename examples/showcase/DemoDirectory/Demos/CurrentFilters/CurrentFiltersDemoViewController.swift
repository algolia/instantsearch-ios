//
//  CurrentFiltersDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class CurrentFiltersDemoViewController: UIViewController {

  let filterState: FilterState
  let currentFiltersListConnector: CurrentFiltersConnector
  let currentFiltersListConnector2: CurrentFiltersConnector

  let currentFiltersController: CurrentFilterListTableController
  let currentFiltersController2: SearchTextFieldCurrentFiltersController

  let searchStateViewController: SearchStateViewController

  let tableView: UITableView
  let searchTextField: UISearchTextField

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchStateViewController = .init()
    filterState = .init()

    tableView = .init()
    searchTextField = .init()

    currentFiltersController = .init(tableView: tableView)
    currentFiltersController2 = .init(searchTextField: searchTextField)
    
    currentFiltersListConnector = .init(filterState: filterState,
                                        controller: currentFiltersController)

    currentFiltersListConnector2 = .init(filterState: filterState,
                                         groupIDs: [.or(name: "filterFacets", filterType: .facet)],
                                         controller: currentFiltersController2)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupUI()
  }
  
}

private extension CurrentFiltersDemoViewController {

  func setup() {

    searchStateViewController.connectFilterState(filterState)

    let filterFacet1 = Filter.Facet(attribute: "category", value: "table")
    let filterFacet2 = Filter.Facet(attribute: "category", value: "chair")
    let filterFacet3 = Filter.Facet(attribute: "category", value: "clothes")
    let filterFacet4 = Filter.Facet(attribute: "category", value: "kitchen")

    filterState[or: "filterFacets"].add(filterFacet1,
                                        filterFacet2,
                                        filterFacet3,
                                        filterFacet4)
    
    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)

    filterState[and: "filterNumerics"].add(filterNumeric1,
                                           filterNumeric2)

    filterState.notifyChange()
  }

  func setupUI() {

    view.backgroundColor = .white

    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16

    view.addSubview(mainStackView)

    mainStackView.pin(to: view.safeAreaLayoutGuide)

    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    let searchTextFieldContainer = UIView()
    searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
    searchTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    searchTextFieldContainer.addSubview(searchTextField)
    searchTextField.pin(to: searchTextFieldContainer, insets: UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5))

    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(searchTextFieldContainer)
    mainStackView.addArrangedSubview(tableView)
    
  }

}

