//
//  QuerySuggestionsDemoViewController.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import UIKit
import InstantSearch

public class QuerySuggestionsDemoViewController: UIViewController {

  let searchController: UISearchController
  let searcher: MultiSearcher

  let searchBoxConnector: SearchBoxConnector
  let textFieldController: TextFieldController

  let suggestionsHitsConnector: HitsConnector<QuerySuggestion>
  let suggestionsViewController: SuggestionsTableViewController

  let resultsHitsConnector: HitsConnector<Hit<StoreItem>>
  let resultsViewController: StoreItemsTableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    searcher = .init(client: .ecommerce)

    let suggestionsSearcher = searcher.addHitsSearcher(indexName: .ecommerceSuggestions)
    suggestionsViewController = .init(style: .plain)
    suggestionsHitsConnector = HitsConnector(searcher: suggestionsSearcher,
                                             interactor: .init(infiniteScrolling: .off),
                                             controller: suggestionsViewController)

    let resultsSearcher = searcher.addHitsSearcher(indexName: .ecommerceProducts)
    resultsViewController = .init(style: .plain)
    resultsHitsConnector = HitsConnector(searcher: resultsSearcher,
                                         interactor: .init(),
                                         controller: resultsViewController)

    searchController = .init(searchResultsController: suggestionsViewController)

    textFieldController = .init(searchBar: searchController.searchBar)
    searchBoxConnector = .init(searcher: searcher,
                               controller: textFieldController)

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  private func setup() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false

    searchController.showsSearchResultsController = true

    addChild(resultsViewController)
    resultsViewController.didMove(toParent: self)

    searchBoxConnector.connectController(suggestionsViewController)
    searchBoxConnector.interactor.onQuerySubmitted.subscribe(with: searchController) { (searchController, _) in
      searchController.dismiss(animated: true, completion: .none)
    }

    searcher.search()
  }

  private func configureUI() {
    title = "Query Suggestions"
    view.backgroundColor = .systemBackground
    let resultsView = resultsViewController.view!
    resultsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(resultsView)
    NSLayoutConstraint.activate([
      resultsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      resultsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      resultsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

}
