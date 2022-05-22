//
//  MultiIndexDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 09/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

enum MultiIndexDemoSection: CaseIterable {

  case suggestions
  case products

  var index: Int {
    return MultiIndexDemoSection.allCases.firstIndex(of: self)!
  }

  var title: String {
    switch self {
    case .suggestions:
      return "Popular searches"
    case .products:
      return "Products"
    }
  }

  var indexName: IndexName {
    switch self {
    case .suggestions:
      return .ecommerceSuggestions

    case .products:
      return .ecommerceProducts
    }
  }

  var cellIdentifier: String {
    switch self {
    case .suggestions:
      return "suggestionsCell"
    case .products:
      return "productCell"
    }
  }

}

class MultiIndexDemoViewController: UIViewController {

  let searchController: UISearchController
  let demoController: MultiIndexDemoController
  let textFieldController: TextFieldController
  let hitsViewController: MultiIndexHitsViewController

  init() {
    demoController = .init()
    hitsViewController = .init()
    searchController = .init(searchResultsController: hitsViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    demoController.searchBoxConnector.connectController(textFieldController)
    demoController.productsHitsConnector.connectController(hitsViewController.productsCollectionViewController)
    demoController.suggestionsHitsConnector.connectController(hitsViewController.suggestionsCollectionViewController)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

}

private extension MultiIndexDemoViewController {

  func setupUI() {
    view.backgroundColor = .systemBackground
    definesPresentationContext = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }

}

class ProductsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {

  var hitsSource: HitsInteractor<Hit<StoreItem>>?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .clear
    collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.products.cellIdentifier)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.height - 10)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    hitsSource?.numberOfHits() ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiIndexDemoSection.products.cellIdentifier, for: indexPath)
    if let item = hitsSource?.hit(atIndex: indexPath.row) {
      (cell as? ProductCollectionViewCell)?.setup(with: item)
    }
    return cell
  }

}

class SuggestionsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {

  var hitsSource: HitsInteractor<QuerySuggestion>?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .clear
    collectionView.register(SuggestionCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.suggestions.cellIdentifier)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.bounds.width / 3, height: 40)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    hitsSource?.numberOfHits() ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiIndexDemoSection.suggestions.cellIdentifier, for: indexPath)
    if let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
      (cell as? SuggestionCollectionViewCell)?.setup(with: suggestion)
    }
    return cell
  }

}

class MultiIndexHitsViewController: UIViewController {

  let suggestionsCollectionViewController: SuggestionsCollectionViewController
  let productsCollectionViewController: ProductsCollectionViewController

  init() {
    let productsFlowLayout = UICollectionViewFlowLayout()
    productsFlowLayout.scrollDirection = .horizontal
    productsCollectionViewController = .init(collectionViewLayout: productsFlowLayout)

    let suggestionsFlowLayout = UICollectionViewFlowLayout()
    suggestionsFlowLayout.scrollDirection = .horizontal
    suggestionsCollectionViewController = .init(collectionViewLayout: suggestionsFlowLayout)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  func setupUI() {
    view.backgroundColor = UIColor.systemGray6
    configureCollectionView()

    addChild(productsCollectionViewController)
    productsCollectionViewController.didMove(toParent: self)

    addChild(suggestionsCollectionViewController)
    suggestionsCollectionViewController.didMove(toParent: self)

    suggestionsCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    productsCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints =  false
    stackView.axis = .vertical
    stackView.spacing = 16

    let suggestionsTitleLabel = UILabel()
    suggestionsTitleLabel.text = MultiIndexDemoSection.suggestions.title
    suggestionsTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    stackView.addArrangedSubview(suggestionsTitleLabel)
    stackView.addArrangedSubview(suggestionsCollectionViewController.collectionView)

    let productsTitleLabel = UILabel()
    productsTitleLabel.text = MultiIndexDemoSection.products.title
    productsTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    stackView.addArrangedSubview(productsTitleLabel)
    stackView.addArrangedSubview(productsCollectionViewController.collectionView)

    stackView.addArrangedSubview(.spacer)

    view.addSubview(stackView)
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.pin(to: view.safeAreaLayoutGuide, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
  }

  func configureCollectionView() {
    [
      productsCollectionViewController,
      suggestionsCollectionViewController
    ].forEach { controller in
      controller.view?.translatesAutoresizingMaskIntoConstraints = false
      controller.view?.backgroundColor = .clear
    }
  }

}
