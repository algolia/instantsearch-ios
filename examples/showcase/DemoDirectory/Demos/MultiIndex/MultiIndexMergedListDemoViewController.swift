//
//  MultiIndexMergedListDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 21/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

enum QuerySuggestionsAndHits {
  
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let suggestionsInteractor: HitsInteractor<QuerySuggestion>
    let hitsInteractor: HitsInteractor<Hit<StoreItem>>
    
    let searchResultsController: SearchResultsController
      
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(appID: SearchClient.newDemo.applicationID,
                       apiKey: SearchClient.newDemo.apiKey)
      searchResultsController = .init(style: .plain)
      suggestionsInteractor = .init(infiniteScrolling: .off)
      hitsInteractor = .init(infiniteScrolling: .off)
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: searcher,
                                  controller: textFieldController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      configureUI()
      
      let suggestionsSearcher = searcher.addHitsSearcher(indexName: Index.Ecommerce.suggestions)
      suggestionsSearcher.request.query.hitsPerPage = 5
      suggestionsInteractor.connectSearcher(suggestionsSearcher)
      searchResultsController.suggestionsHitsInteractor = suggestionsInteractor
      
      let hitsSearchers = searcher.addHitsSearcher(indexName: Index.Ecommerce.products)
      hitsInteractor.connectSearcher(hitsSearchers)
      searchResultsController.hitsInteractor = hitsInteractor
      
      searcher.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }
    
    func configureUI() {
      view.backgroundColor = .white
      definesPresentationContext = true
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }
    
  }
  
}

extension QuerySuggestionsAndHits {
      
  class SearchResultsController: UITableViewController {
    
    enum Section: Int, CaseIterable {
      case suggestions
      case hits
      
      var title: String {
        switch self {
        case .suggestions:
          return "Suggestions"
        case .hits:
          return "Products"
        }
      }
      
      var cellReuseIdentifier: String {
        switch self {
        case .suggestions:
          return "suggestionCellID"
        case .hits:
          return "productCellID"
        }
      }
          
      init?(section: Int) {
        self.init(rawValue: section)
      }
      
      init?(indexPath: IndexPath) {
        self.init(section: indexPath.section)
      }
      
    }
        
    weak var suggestionsHitsInteractor: HitsInteractor<QuerySuggestion>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = suggestionsHitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }
    
    weak var hitsInteractor: HitsInteractor<Hit<StoreItem>>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = hitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: Section.suggestions.cellReuseIdentifier)
      tableView.register(StoreItemTableViewCell.self, forCellReuseIdentifier: Section.hits.cellReuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(section: section) else { return 0 }
      switch section {
      case .suggestions:
        return suggestionsHitsInteractor?.numberOfHits() ?? 0
      case .hits:
        return hitsInteractor?.numberOfHits() ?? 0
      }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let section = Section(indexPath: indexPath) else { return UITableViewCell() }
      
      let cell: UITableViewCell
      
      switch section {
      case .suggestions:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.suggestions.cellReuseIdentifier, for: indexPath)
        if
          let searchSuggestionCell = cell as? SearchSuggestionTableViewCell,
          let suggestion = suggestionsHitsInteractor?.hit(atIndex: indexPath.row) {
            searchSuggestionCell.setup(with: suggestion)
        }

      case .hits:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.hits.cellReuseIdentifier, for: indexPath)
        if
          let productTableViewCell = cell as? StoreItemTableViewCell,
          let product = hitsInteractor?.hit(atIndex: indexPath.row) {
            productTableViewCell.setup(with: product)
        }
      }
      
      return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(section: section) else { return nil }
      switch section {
      case .suggestions where suggestionsHitsInteractor?.numberOfHits() ?? 0 == 0:
        return nil
      case .hits where hitsInteractor?.numberOfHits() ?? 0 == 0:
        return nil
      default:
        return section.title
      }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let section = Section(indexPath: indexPath) else { return 0 }
      switch section {
      case .suggestions:
        return 44
      case .hits:
        return 100
      }
    }
    
  }
  
}
