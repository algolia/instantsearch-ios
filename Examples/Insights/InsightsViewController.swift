//
//  InsightsViewController.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/05/2022.
//

import UIKit
import InstantSearchInsights
import InstantSearch

class InsightsViewController: UIViewController {

  let searchController: UISearchController
  let searcher: HitsSearcher

  let searchBoxConnector: SearchBoxConnector
  let textFieldController: TextFieldController

  let hitsConnector: HitsConnector<Hit<StoreItem>>
  let searchResultsController: StoreItemsTableViewController

  let hitsTracker: HitsTracker

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
    let insights = Insights.register(appId: SearchClient.ecommerce.applicationID, apiKey: SearchClient.ecommerce.apiKey)
    hitsTracker = .init(eventName: "demo",
                        searcher: searcher,
                        insights: insights)
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
    title = "Insights"
    view.backgroundColor = .systemBackground
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
    searcher.search()

    searchResultsController.didSelect = { [weak self]  index, hit in
      self?.hitsTracker.trackClick(for: hit, position: index)
    }

  }

}
