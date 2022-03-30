//
//  SingleIndexSnippet.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class SingleIndexSnippetViewController: UIViewController {
  
  let searcher: HitsSearcher = .init(appID: "latency",
                                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                     indexName: "bestbuy")
  
  let filterState: FilterState = .init()
  
  let searchBar: UISearchBar = .init()
  let queryInputInteractor: QueryInputInteractor = .init()
  lazy var textFieldController: TextFieldController = {
    return .init(searchBar: searchBar)
  }()
  
  let statsInteractor: StatsInteractor = .init()
  let statsController: LabelStatsController = .init(label: UILabel())
  
  let hitsInteractor: HitsInteractor<JSON> = .init()
  let hitsTableViewController: HitsViewController = .init(style: .plain)
  
  let categoryInteractor: FacetListInteractor = .init(selectionMode: .single)
  let categoryTableViewController: UITableViewController = .init()
  lazy var categoryListController: FacetListTableController = {
    return .init(tableView: categoryTableViewController.tableView, titleDescriptor: .none)
  }()
  
  var tagsConnection: Connection?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    configureUI()
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  func setup() {
    
    searcher.connectFilterState(filterState)
    
    queryInputInteractor.connectSearcher(searcher)
    queryInputInteractor.connectController(textFieldController)
    
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    hitsInteractor.connectFilterState(filterState)
    
    categoryInteractor.connectSearcher(searcher, with: "category")
    categoryInteractor.connectFilterState(filterState, with: "category", operator: .and)
    categoryInteractor.connectController(categoryListController, with: FacetListPresenter(sortBy: [.isRefined]))
    
    if #available(iOS 13.0, *) {
      tagsConnection = FacetSearchTextFieldConnection(filterState: filterState, searchTextField: searchBar.searchTextField)
      tagsConnection?.connect()
      searchBar.searchTextField.delegate = self
    }
    
    searcher.search()
  }
  
  func configureUI() {
  
    view.backgroundColor = .white
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchBar.searchBarStyle = .minimal
    
    let filterButton = UIButton()
    filterButton.setTitleColor(.black, for: .normal)
    filterButton.setTitle("Filter", for: .normal)
    filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
    
    let searchBarFilterButtonStackView = UIStackView()
    searchBarFilterButtonStackView.translatesAutoresizingMaskIntoConstraints = false
    searchBarFilterButtonStackView.spacing = 4
    searchBarFilterButtonStackView.axis = .horizontal
    searchBarFilterButtonStackView.addArrangedSubview(searchBar)
    searchBarFilterButtonStackView.addArrangedSubview(filterButton)
    let spacer = UIView()
    spacer.widthAnchor.constraint(equalToConstant: 4).isActive = true
    searchBarFilterButtonStackView.addArrangedSubview(spacer)
    
    stackView.addArrangedSubview(searchBarFilterButtonStackView)
    
    let statsLabel = statsController.label
    statsLabel.translatesAutoresizingMaskIntoConstraints = false
    statsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    stackView.addArrangedSubview(statsLabel)

    stackView.addArrangedSubview(hitsTableViewController.tableView)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      ])
    
    categoryTableViewController.title = "Category"
    categoryTableViewController.view.backgroundColor = .white
    
  }
  
  @objc func showFilters() {
    let navigationController = UINavigationController(rootViewController: categoryTableViewController)
    categoryTableViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissFilters))
    present(navigationController, animated: true, completion: .none)
  }
  
  @objc func dismissFilters() {
    dismiss(animated: true, completion: .none)
  }
  
}

extension SingleIndexSnippetViewController: UISearchTextFieldDelegate {
  
  
  
}

extension SingleIndexSnippetViewController {
  
  class HitsViewController: UITableViewController, HitsController {
    
    var hitsSource: HitsInteractor<JSON>?
      
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let hit = hitsSource?.hit(atIndex: indexPath.row) else { return .init() }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      cell.textLabel?.text = [String: Any](hit)?["name"] as? String
      return cell
    }
    
  }

}
