//
//  SearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class PetSmartDemoController {
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<PetSmartStoreItem>>
  let searchBoxConnector: SearchBoxConnector
  let statsConnector: StatsConnector
  let loadingConnector: LoadingConnector
  let filterState: FilterState
  let brandFacetList: FacetListConnector
  let ratingFacetList: FacetListConnector

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    searcher = .init(appID: "0ZV04HYYVJ",
                     apiKey: "f220c49aa52fca828fe5265965a0cab3",
                     indexName: "p-development-US__products___")
    hitsInteractor = .init()
    filterState = .init()
    brandFacetList = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "brand",
                           operator: .or)
    ratingFacetList = .init(searcher: searcher,
                            filterState: filterState,
                            attribute: "customBvAverageRating",
                            operator: .or)
    searchBoxConnector = .init(searcher: searcher,
                               searchTriggeringMode: searchTriggeringMode)
    statsConnector = .init(searcher: searcher)
    loadingConnector = .init(searcher: searcher)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectFilterState(filterState)
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
    let detailsStackView = UIStackView()
    detailsStackView.translatesAutoresizingMaskIntoConstraints = false
    detailsStackView.axis = .horizontal
    detailsStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    detailsStackView.isLayoutMarginsRelativeArrangement = true
    detailsStackView.addArrangedSubview(statsController.label)
    detailsStackView.addArrangedSubview(.spacer)
    detailsStackView.addArrangedSubview(loadingController.activityIndicator)
    stackView.addArrangedSubview(detailsStackView)
    stackView.addArrangedSubview(hitsViewController.view)
  }
}

class SearchDemoViewController: UIViewController {
  let demoController: PetSmartDemoController
  let searchController: UISearchController
  let textFieldController: TextFieldController
  let resultsViewController: PetSmartResultsViewController
  
  lazy var filtersViewController: UIViewController = {
    let filtersViewController = FiltersViewController()
    filtersViewController.title = "Brands"
    let clearIconImage = UIImage(systemName: "trash.circle")
    filtersViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: clearIconImage,
                                                                              style: .plain,
                                                                              target: self,
                                                                              action: #selector(tapClearFiltersButton))
    let presenter = FacetListPresenter(sortBy: [.isRefined, .count(order: .ascending), .alphabetical(order: .ascending)])
    demoController.brandFacetList.connectController(filtersViewController.tableController, with: presenter)
    let navigationController = UINavigationController(rootViewController: filtersViewController)
    return navigationController
  }()

  init(searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
    demoController = PetSmartDemoController()
    resultsViewController = .init(searcher: demoController.searcher)
    searchController = .init(searchResultsController: resultsViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    super.init(nibName: .none, bundle: .none)
  }
  
  @objc func tapFilterButton(_ sender: UIButton) {
    present(filtersViewController, animated: true)
  }
  
  @objc func tapClearFiltersButton(_ sender: UIButton) {
    demoController.filterState.removeAll(for: "brand")
    demoController.filterState.notifyChange()
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
    demoController.searcher.search()
    let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")
    let clearIconImage = UIImage(systemName: "trash.circle")
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: filterImage,
                      style: .plain,
                      target: self,
                      action: #selector(tapFilterButton)),
      UIBarButtonItem(image: clearIconImage,
                      style: .plain,
                      target: self,
                      action: #selector(tapClearFiltersButton)),
    ]
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
