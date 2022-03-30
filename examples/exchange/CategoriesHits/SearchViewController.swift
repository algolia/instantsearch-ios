//
//  SearchViewController.swift
//  CategoriesHits
//
//  Created by Vladislav Fitc on 19/11/2021.
//

import Foundation
import UIKit
import InstantSearch

enum CategoriesHits {
    
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let categoriesInteractor: FacetListInteractor
    let hitsInteractor: HitsInteractor<Hit<Product>>
    
    let searchResultsController: SearchResultsController
      
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(appID: "latency",
                       apiKey: "6be0576ff61c053d5f9a3225e2a90f76")
      searchResultsController = .init(style: .plain)
      categoriesInteractor = .init()
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
      
      let facetsSearcher = searcher.addFacetsSearcher(indexName: "instant_search",
                                                      attribute: "categories")
      categoriesInteractor.connectFacetSearcher(facetsSearcher)
      searchResultsController.categoriesInteractor = categoriesInteractor
      
      let hitsSearchers = searcher.addHitsSearcher(indexName: "instant_search")
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
