//
//  VoiceInputDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchVoiceOverlay

class VoiceInputDemoViewController: UIViewController, UISearchBarDelegate {
  
  let searcher: HitsSearcher
  let searchConnector: SearchConnector<Hit<StoreItem>>
  
  let searchController: UISearchController
  let resultsViewController: ResultsViewController
  let voiceOverlayController: VoiceOverlayController

  init() {
    searcher = .init(client: .newDemo,
                     indexName: Index.Ecommerce.products)
    resultsViewController = .init(searcher: searcher)
    voiceOverlayController = .init()
    searchController = .init(searchResultsController: resultsViewController)
    searchConnector = .init(searcher: searcher,
                            searchController: searchController,
                            hitsInteractor: .init(),
                            hitsController: resultsViewController.hitsViewController)
    searchConnector.connect()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searcher.search()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  private func setupUI() {
    title = "Voice Search"
    view.backgroundColor = .white
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
    navigationItem.searchController = searchController
    searchController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.delegate = self
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    voiceOverlayController.start(on: self.navigationController!) { [weak self] (text, isFinal, _) in
      self?.searchConnector.queryInputConnector.interactor.query = text
    } errorHandler: { error in
      guard let error = error else { return }
      DispatchQueue.main.async { [weak self] in
        self?.present(error)
      }
    }
  }
  
  func present(_ error: Error) {
    let alertController = UIAlertController(title: "Error",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    alertController.addAction(.init(title: "OK",
                                    style: .cancel,
                                    handler: .none))
    navigationController?.present(alertController,
                                  animated: true,
                                  completion: nil)
  }

}
