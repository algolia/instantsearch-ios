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
  
  // Search controller responsible for the presentation of suggestions
  let searchController: UISearchController
  
  // Query input interactor + controller
  let queryInputInteractor: QueryInputInteractor
  let textFieldController: TextFieldController
    
  // Search suggestions interactor + controller
  let suggestionsHitsInteractor: HitsInteractor<QuerySuggestion>
  let suggestionsViewController: SuggestionsTableViewController
  
  // Search results interactor + controller
  let resultsHitsInteractor: HitsInteractor<Hit<StoreItem>>
  let resultsViewController: StoreItemsTableViewController
  
  // Multi searcher which aggregates hits and suggestions search
  let multiSearcher: MultiSearcher
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    suggestionsHitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    suggestionsViewController = .init(style: .plain)
    
    resultsHitsInteractor = .init()
    resultsViewController = .init(style: .plain)
    
    searchController = .init(searchResultsController: suggestionsViewController)
        
    queryInputInteractor = .init()
    textFieldController = .init(searchBar: searchController.searchBar)
    
    multiSearcher = .init(appID: SearchClient.newDemo.applicationID,
                          apiKey: SearchClient.newDemo.apiKey)
    
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
      
  private func configureUI() {
    view.backgroundColor = .white
    searchController.showsSearchResultsController = true
    addChild(resultsViewController)
    resultsViewController.didMove(toParent: self)
    let resultsView = resultsViewController.view!
    resultsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(resultsView)
    NSLayoutConstraint.activate([
      resultsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      resultsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      resultsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
  private func setup() {
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    let suggestionsSearcher = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.suggestions)
    suggestionsHitsInteractor.connectSearcher(suggestionsSearcher)

    let resultsSearchers = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.products)
    resultsHitsInteractor.connectSearcher(resultsSearchers)
    
    queryInputInteractor.connectSearcher(multiSearcher)
    queryInputInteractor.connectController(textFieldController)
    queryInputInteractor.connectController(suggestionsViewController)
    
    queryInputInteractor.onQuerySubmitted.subscribe(with: searchController) { (searchController, _) in
      searchController.dismiss(animated: true, completion: .none)
    }
        
    suggestionsHitsInteractor.connectController(suggestionsViewController)
    resultsHitsInteractor.connectController(resultsViewController)
    
    multiSearcher.search()
  }
  
}
