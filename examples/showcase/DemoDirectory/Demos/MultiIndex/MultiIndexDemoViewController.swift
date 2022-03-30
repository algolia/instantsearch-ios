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
      return Index.Ecommerce.suggestions
      
    case .products:
      return Index.Ecommerce.products
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
  
  let textFieldController: TextFieldController
  
  let queryInputConnector: QueryInputConnector
  let searchBar: UISearchBar
  
  let multiSearcher: MultiSearcher
  let suggestionsHitsConnector: HitsConnector<QuerySuggestion>
  let productsHitsConnector: HitsConnector<Hit<StoreItem>>
  
  let hitsViewController: MultiIndexHitsViewController
  
  init() {
    searchBar = UISearchBar()
    
    textFieldController = .init(searchBar: searchBar)
    
    hitsViewController = .init()
    
    multiSearcher = MultiSearcher(appID: SearchClient.newDemo.applicationID,
                                  apiKey: SearchClient.newDemo.apiKey)
    
    let suggestionsSearcher = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.suggestions)
    let productsSearcher = multiSearcher.addHitsSearcher(indexName: Index.Ecommerce.products)
    
    queryInputConnector = .init(searcher: multiSearcher,
                                controller: textFieldController)
    productsHitsConnector = .init(searcher: productsSearcher,
                                  controller: hitsViewController.productsCollectionViewController)
    suggestionsHitsConnector = .init(searcher: suggestionsSearcher,
                                     controller: hitsViewController.suggestionsCollectionViewController)
    
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
}

private extension MultiIndexDemoViewController {
  
  func setup() {
    multiSearcher.search()
    addChild(hitsViewController)
    hitsViewController.didMove(toParent: self)
  }
  
  func setupUI() {
    view.backgroundColor = UIColor(hexString: "#f7f8fa")
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = .px16 / 2
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.searchBarStyle = .minimal
    searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(hitsViewController.view)
    stackView.addArrangedSubview(UIView().set(\.translatesAutoresizingMaskIntoConstraints, to: false))
  }
  
}

class ProductsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {
  
  var hitsSource: HitsInteractor<Hit<StoreItem>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .clear
    collectionView.register(StoreItemCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.products.cellIdentifier)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.height - 10)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiIndexDemoSection.products.cellIdentifier, for: indexPath)
    if let item = hitsSource?.hit(atIndex: indexPath.row) {
      (cell as? StoreItemCollectionViewCell)?.setup(with: item)
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
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width / 3, height: 40)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
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
    configureCollectionView()
    
    addChild(productsCollectionViewController)
    productsCollectionViewController.didMove(toParent: self)
    
    addChild(suggestionsCollectionViewController)
    suggestionsCollectionViewController.didMove(toParent: self)
    
    suggestionsCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    productsCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    
    let stackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
    
    stackView.addArrangedSubview(UILabel()
      .set(\.text, to: MultiIndexDemoSection.suggestions.title)
      .set(\.font, to: .systemFont(ofSize: 15, weight: .semibold))
    )
    stackView.addArrangedSubview(suggestionsCollectionViewController.collectionView)
    
    stackView.addArrangedSubview(UILabel()
      .set(\.text, to: MultiIndexDemoSection.products.title)
      .set(\.font, to: .systemFont(ofSize: 15, weight: .semibold))
    )
    stackView.addArrangedSubview(productsCollectionViewController.collectionView)
    
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
