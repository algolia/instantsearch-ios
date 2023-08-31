//
//  SearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import InstantSearchSwiftUI
import UIKit

class PetSmartDemoController {
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<PetSmartStoreItem>>
  let searchBoxConnector: SearchBoxConnector
  let statsConnector: StatsConnector
  let loadingConnector: LoadingConnector
  // NumberRange connector to change price
  let priceRangeConnector: NumberRangeConnector<Double>
  let filterState: FilterState

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(appID: "0ZV04HYYVJ",
                     apiKey: "f220c49aa52fca828fe5265965a0cab3",
                     indexName: "r-development-US__products___price-low-to-high")
    hitsInteractor = .init()
    filterState = .init()
    searchBoxConnector = .init(searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    statsConnector = .init(searcher: searcher)
    loadingConnector = .init(searcher: searcher)
    priceRangeConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price.number")
    hitsInteractor.connectSearcher(searcher)
    searcher.connectFilterState(filterState)
  }
}

struct PetSmartStoreItem: Codable {
  let name: String
  let brand: String?
  let price: Price?
  let images: Images
  
  struct Price: Codable {
    let number: Float
    let displayType: String
  }
  
  struct Images: Codable {
    let large: URL?
    let small: URL?
  }
}

extension ProductTableViewCell {
  
  func setup(with productHit: Hit<PetSmartStoreItem>) {
    let product = productHit.object
    itemImageView.sd_setImage(with: product.images.small ?? product.images.large)

    if let highlightedName = productHit.hightlightedString(forKey: "name") {
      titleLabel.attributedText = NSAttributedString(highlightedString: highlightedName,
                                                     attributes: [
                                                       .foregroundColor: UIColor.tintColor
                                                     ])
    } else {
      titleLabel.text = product.name
    }

    if let highlightedDescription = productHit.hightlightedString(forKey: "brand") {
      subtitleLabel.attributedText = NSAttributedString(highlightedString: highlightedDescription,
                                                        attributes: [
                                                          .foregroundColor: UIColor.tintColor
                                                        ])
    } else {
      subtitleLabel.text = product.brand
    }

    if let price = product.price?.number {
      priceLabel.text = "\(price) €"
    }
  }
  
}

class PetSmartResultsViewController: UIViewController {
  let stackView: UIStackView
  let hitsViewController: StoreItemsTableViewController<PetSmartStoreItem>

  let statsConnector: StatsConnector
  let statsController: LabelStatsController

  let loadingConnector: LoadingConnector
  let loadingController: ActivityIndicatorController
  
  // Price controller to be connected to the NumberRangeConnector
  let priceController = NumericRangeController(rangeSlider: .init(frame: .zero))
  let priceObservableController = NumberRangeObservableController<Double>()
  let priceLabel = UILabel()

  // previous request stored here for comparison
  var previousRequest: AlgoliaSearchService.Request?

  init(searcher: HitsSearcher) {
    stackView = .init(frame: .zero)
    hitsViewController = .init(style: .plain)
    statsController = .init(label: .init())
    statsConnector = .init(searcher: searcher, controller: statsController)
    loadingController = .init(activityIndicator: .init())
    loadingConnector = .init(searcher: searcher, controller: loadingController)
    super.init(nibName: nil, bundle: nil)
    addChild(hitsViewController)
    hitsViewController.didMove(toParent: self)
    loadingConnector.disconnect()
    
    hitsViewController.setupCell = { cell, item in
      cell.setup(with: item)
    }
    
    // Here is the implementation
    // Function checking if two requests are different. Page increment/decrement will return false.
    func areDifferent(_ lr: AlgoliaSearchService.Request?, _ rr: AlgoliaSearchService.Request?) -> Bool {
      lr?.indexName != rr?.indexName || lr?.query.query != rr?.query.query || lr?.query.filters != rr?.query.filters
    }
    
    // On request change check if the latest request is different from the previous one
    // If true, start activity indicator animation
    searcher.onRequestChanged.subscribe(with: loadingController) { [weak self] controller, request in
      if areDifferent(request, self?.previousRequest) {
        controller.activityIndicator.startAnimating()
        self?.previousRequest = request
      }
    }.onQueue(.main)
    
    // Subscribe to result and error events to stop the activity indicator animation
    searcher.onResults.subscribe(with: loadingController) { controller, _ in
      controller.activityIndicator.stopAnimating()
    }.onQueue(.main)
    
    searcher.onError.subscribe(with: loadingController) { controller, _ in
      controller.activityIndicator.stopAnimating()
    }.onQueue(.main)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    statsController.label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    loadingController.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingController.activityIndicator.hidesWhenStopped = true
    priceController.view.translatesAutoresizingMaskIntoConstraints = false
    let detailsStackView = UIStackView()
    detailsStackView.translatesAutoresizingMaskIntoConstraints = false
    detailsStackView.axis = .horizontal
    detailsStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    detailsStackView.isLayoutMarginsRelativeArrangement = true
    detailsStackView.addArrangedSubview(statsController.label)
    detailsStackView.addArrangedSubview(.spacer)
    detailsStackView.addArrangedSubview(loadingController.activityIndicator)
    stackView.addArrangedSubview(detailsStackView)
    let priceStackView = UIStackView()
    priceStackView.axis = .vertical
    priceStackView.translatesAutoresizingMaskIntoConstraints = false
    priceStackView.addArrangedSubview(priceController.view)
    priceStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    priceStackView.isLayoutMarginsRelativeArrangement = true
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.text = "No filters applied"
    priceStackView.addArrangedSubview(priceLabel)
    stackView.addArrangedSubview(priceStackView)
    stackView.addArrangedSubview(hitsViewController.view)
  }
}

class SearchDemoViewController: UIViewController {
  let demoController: PetSmartDemoController
  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: PetSmartResultsViewController

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = PetSmartDemoController(searchTriggeringMode: searchTriggeringMode)
    resultsViewController = .init(searcher: demoController.searcher)
    searchController = .init(searchResultsController: resultsViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    super.init(nibName: .none, bundle: .none)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.hitsInteractor.connectController(resultsViewController.hitsViewController)
    demoController.priceRangeConnector.connectController(resultsViewController.priceController)
    demoController.searcher.search()
    demoController.filterState.onChange.subscribe(with: resultsViewController) { resultsController, filters in
      let groups = filters.toFilterGroups()
      if groups.isEmpty {
        resultsController.priceLabel.text = "No filters applied"
      } else {
        if let filter = groups.first(where: { $0.name == "price.number" })?.filters.first(where: { $0.attribute == "price.number" }) as? Filter.Numeric {
          resultsController.priceLabel.text = "Price: \(filter.value)"
        }
      }
    }.onQueue(.main)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  private func setupUI() {
    title = "Search"
    view.backgroundColor = .systemBackground
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
}
