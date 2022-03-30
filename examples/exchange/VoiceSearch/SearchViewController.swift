//
//  SearchViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchVoiceOverlay

enum VoiceSearch {
    
  class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchController: UISearchController
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController
    
    let hitsSearcher: HitsSearcher
    let hitsInteractor: HitsInteractor<Hit<Product>>

    let searchResultsController: SearchResultsController
    let voiceOverlayController: VoiceOverlayController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      hitsSearcher = .init(appID: "latency",
                           apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                           indexName: "instant_search")
      searchResultsController = .init()
      voiceOverlayController = .init()
      hitsInteractor = .init()
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: hitsSearcher,
                                  controller: textFieldController)
      hitsInteractor.connectSearcher(hitsSearcher)
      hitsInteractor.connectController(searchResultsController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      hitsSearcher.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }
    
    func configureUI() {
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
        self?.queryInputConnector.interactor.query = text
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
  
}
