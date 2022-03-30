//
//  RelatedItemsDemoViewController.swift
//  DemoDirectory
//
//  Created by test test on 20/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import SDWebImage

class RelatedItemsDemoViewController: UIViewController {
  
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<StoreItem>>
  
  let queryInputConnector: QueryInputConnector
  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: ResultsViewController
  let recommendController: RecommendController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = .init(client: .recommend,
                          indexName: .recommend)
    self.recommendController = .init(recommendClient: .init(appID: SearchClient.recommend.applicationID,
                                                            apiKey: SearchClient.recommend.apiKey))
    self.resultsViewController = .init(searcher: searcher)
    self.searchController = .init(searchResultsController: resultsViewController)
    self.textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.queryInputConnector = .init(searcher: searcher,
                                     controller: textFieldController)
    hitsInteractor = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    resultsViewController.hitsViewController.didSelect = { [weak self] hit in
      guard let viewController = self else { return }
      viewController.recommendController.presentRelatedItems(for: hit.objectID, from: viewController)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  fileprivate func setupUI() {
    view.backgroundColor = .white
    definesPresentationContext = true
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
    
  private func setup() {
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(resultsViewController.hitsViewController)
    searcher.search()
  }
  
}
