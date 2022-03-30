//
//  FacetSearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class FacetSearchDemoViewController: UIViewController {

  let filterState: FilterState
  let facetSearcher: FacetSearcher
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let categoryController: FacetListTableController
  let categoryListConnector: FacetListConnector
  let queryInputConnector: QueryInputConnector
  
  let searchStateViewController: SearchStateViewController

  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
    filterState = .init()
    facetSearcher = FacetSearcher(client: .demo,
                                  indexName: "mobile_demo_facet_list_search",
                                  facetName: "brand")
    
    categoryController = FacetListTableController(tableView: .init())
    categoryListConnector = .init(searcher: facetSearcher,
                                  filterState: filterState,
                                  attribute: "brand",
                                  operator: .or,
                                  controller: categoryController)

    searchBar = .init()
    textFieldController = TextFieldController(searchBar: searchBar)
    queryInputConnector = QueryInputConnector(searcher: facetSearcher, controller: textFieldController)
    
    searchStateViewController = SearchStateViewController()
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension FacetSearchDemoViewController {
  
  func setup() {
    facetSearcher.search()
    facetSearcher.connectFilterState(filterState)
    searchStateViewController.connectFilterState(filterState)
    searchStateViewController.connectFacetSearcher(facetSearcher)
  }

  func setupUI() {
    
    view.backgroundColor = .white
    
    let tableView = categoryController.tableView
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    searchBar
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.searchBarStyle, to: .minimal)

    let stackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(searchStateViewController.view)
    stackView.addArrangedSubview(tableView)
    
  }

}

