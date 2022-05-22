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

class VoiceSearchViewController: UIViewController {

  let searchController: UISearchController
  let searcher: HitsSearcher

  let searchBoxConnector: SearchBoxConnector
  let textFieldController: TextFieldController

  let hitsConnector: HitsConnector<Hit<StoreItem>>
  let searchResultsController: StoreItemsTableViewController

  let voiceOverlayController: VoiceOverlayController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = .init(client: .ecommerce,
                     indexName: .ecommerceProducts)
    searchResultsController = .init()
    hitsConnector = .init(searcher: searcher,
                          controller: searchResultsController)
    searchController = .init(searchResultsController: searchResultsController)
    textFieldController = .init(searchBar: searchController.searchBar)
    searchBoxConnector = .init(searcher: searcher,
                               controller: textFieldController)
    voiceOverlayController = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  private func setup() {
    title = "Voice Search"
    view.backgroundColor = .systemBackground
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
    searchController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.delegate = self
    searcher.search()
  }

  private func present(_ error: Error) {
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

extension VoiceSearchViewController: UISearchBarDelegate {

  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    voiceOverlayController.start(on: self.navigationController!) { [weak self] (text, _, _) in
      self?.searchBoxConnector.interactor.query = text
    } errorHandler: { error in
      guard let error = error else { return }
      DispatchQueue.main.async { [weak self] in
        self?.present(error)
      }
    }
  }

}
