//
//  MultiIndexCommerceDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

struct Brand: Codable {
  let name: String
}

class MultiIndexCommerceDemoViewController: UIViewController, InstantSearchCore.MultiIndexHitsController {
  
  func reload() {
    itemsCollectionView.reloadData()
    brandsCollectionView.reloadData()
  }
  
  func scrollToTop() {
    itemsCollectionView.scrollToFirstNonEmptySection()
    brandsCollectionView.scrollToFirstNonEmptySection()
  }

  weak var hitsSource: MultiIndexHitsSource?
  
  let multiIndexSearcher: MultiIndexSearcher
  let textFieldController: TextFieldController
  let queryInputInteractor: QueryInputInteractor
  let multiIndexHitsInteractor: MultiIndexHitsInteractor
  let searchBar: UISearchBar
  let itemsCollectionView: UICollectionView
  let brandsCollectionView: UICollectionView
  let cellIdentifier = "CellID"

  init() {
    searchBar = UISearchBar()
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    itemsCollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
    
    let actorsFlowLayout = UICollectionViewFlowLayout()
    actorsFlowLayout.scrollDirection = .horizontal
    brandsCollectionView = .init(frame: .zero, collectionViewLayout: actorsFlowLayout)
    
    let indices = [
      Section.items.index,
      Section.brands.index,
    ]

    multiIndexSearcher = .init(appID: "latency", apiKey: "afc3dd66dd1293e2e2736a5a51b05c0a", indexNames: ["instant_search", "instantsearch_query_suggestions"])
    
    let hitsInteractors: [AnyHitsInteractor] = [
      HitsInteractor<Hit<ShopItem>>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
      HitsInteractor<Hit<QuerySuggestion>>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
    ]
    
    multiIndexHitsInteractor = .init(hitsInteractors: hitsInteractors)

    textFieldController = .init(searchBar: searchBar)
    queryInputInteractor = .init()
    
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

private extension MultiIndexCommerceDemoViewController {
  
  func section(for collectionView: UICollectionView) -> Section? {
    switch collectionView {
    case itemsCollectionView:
      return .items
      
    case brandsCollectionView:
      return .brands

    default:
      return .none
    }
  }
  
  func setup() {
    queryInputInteractor.connectSearcher(multiIndexSearcher)
    queryInputInteractor.connectController(textFieldController)

    multiIndexHitsInteractor.connectSearcher(multiIndexSearcher)
    multiIndexHitsInteractor.connectController(self)
    
    multiIndexSearcher.search()
  }
  
  func configure(_ collectionView: UICollectionView) {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
  }
  
  func configureCollectionView() {
    itemsCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Section.items.cellIdentifier)
    brandsCollectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Section.brands.cellIdentifier)
    configure(itemsCollectionView)
    configure(brandsCollectionView)
  }
  
  func setupUI() {
    
    configureCollectionView()

    view.backgroundColor = UIColor(hexString: "#f7f8fa")
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = .px16 / 2
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.searchBarStyle = .minimal
    searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    itemsCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    brandsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    brandsCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let moviesTitleLabel = UILabel(frame: .zero)
    moviesTitleLabel.text = "   Items"
    moviesTitleLabel.font = .systemFont(ofSize: 15, weight: .black)
    moviesTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    let actorsTitleLabel = UILabel(frame: .zero)
    actorsTitleLabel.text = "   Suggestions"
    actorsTitleLabel.font = .systemFont(ofSize: 15, weight: .black)
    actorsTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(moviesTitleLabel)
    stackView.addArrangedSubview(itemsCollectionView)
    let spacer = UIView()
    spacer.translatesAutoresizingMaskIntoConstraints = false
    spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
    stackView.addSubview(spacer)
    stackView.addArrangedSubview(actorsTitleLabel)
    stackView.addArrangedSubview(brandsCollectionView)
    stackView.addArrangedSubview(UIView())
    
  }

}

extension MultiIndexCommerceDemoViewController {
  
  enum Section: Int {
    
    case items
    case brands
    
    init?(section: Int) {
      self.init(rawValue: section)
    }
    
    init?(indexPath: IndexPath) {
      self.init(rawValue: indexPath.section)
    }
    
    var title: String {
      switch self {
      case .items:
        return "Items"
      case .brands:
        return "Brands"
      }
    }
    
    var index: Index {
      switch self {
      case .items:
        return .demo(withName: "instant_search")
        
      case .brands:
        return .demo(withName: "instantsearch_query_suggestions")
      }
    }
    
    var cellIdentifier: String {
      switch self {
      case .items:
        return "itemsCell"
      case .brands:
        return "brandCell"
      }
    }
    
  }
  
}

extension MultiIndexCommerceDemoViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = self.section(for: collectionView) else { return 0 }
    return hitsSource?.numberOfHits(inSection: section.rawValue) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let section = self.section(for: collectionView) else { return UICollectionViewCell() }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellIdentifier, for: indexPath)
    
    switch section {
    case .items:
      if let shopItem: Hit<ShopItem> = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.rawValue) {
        (cell as? MovieCollectionViewCell).flatMap(MovieHitCellViewState().configure)?(shopItem)
      }
      
    case .brands:
      if let brand: Hit<QuerySuggestion> = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.rawValue) {
        (cell as? ActorCollectionViewCell).flatMap(ActorHitCollectionViewCellViewState().configure)?(brand)
      }
    }

    return cell
  }
  
}

extension MultiIndexCommerceDemoViewController: UICollectionViewDelegateFlowLayout {
  
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
    guard let section = section(for: collectionView) else { return .zero }
    switch section {
    case .items:
      return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.height - 10)

    case .brands:
      return CGSize(width: collectionView.bounds.width / 3, height: 40)
    }
  }

}

