//
//  CollectionViewMultiHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class CollectionViewMultiHitsDataSource: NSObject {
  
  private typealias CellConfigurator = (Int) throws -> UICollectionViewCell
  
  public weak var dataSource: MultiHitsDataSource? {
    didSet {
      cellConfigurators.removeAll()
    }
  }
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping HitViewConfigurator<Hit, UICollectionViewCell>) {
    cellConfigurators[section] = { [weak self] row in
      guard let dataSource = self?.dataSource else { return UICollectionViewCell() }
      let sectionViewModel = try dataSource.hitsViewModel(atIndex: section) as HitsViewModel<Hit>
      guard let hit = sectionViewModel.hitForRow(atIndex: row) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits ViewModel")
        return UICollectionViewCell()
      }
      return cellConfigurator(hit)
    }
  }
  
}

extension CollectionViewMultiHitsDataSource: UICollectionViewDataSource {
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let numberOfSections = dataSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let numberOfRows = dataSource?.numberOfRows(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(indexPath.row) ?? UICollectionViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

open class CollectionViewMultiHitsDelegate: NSObject {
  
  typealias ClickHandler = (Int) throws -> Void
  
  public weak var dataSource: MultiHitsDataSource? {
    didSet {
      clickHandlers.removeAll()
    }
  }
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping HitClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] row in
      guard let dataSource = self?.dataSource else { return }
      let sectionViewModel = try dataSource.hitsViewModel(atIndex: section) as HitsViewModel<Hit>
      guard let hit = sectionViewModel.hitForRow(atIndex: row) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits ViewModel")
        return
      }
      clickHandler(hit)
    }
  }
  
}

extension CollectionViewMultiHitsDelegate: UICollectionViewDelegate {
  
  public func tableView(_ tableView: UICollectionView, didSelectRowAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

class CollectionViewMultiHitsWidget: NSObject, MultiHitsWidget {
  
  typealias SingleHitView = UITableViewCell
  
  let collectionView: UICollectionView
  
  public weak var viewModel: MultiHitsViewModel? {
    didSet {
      dataSource?.dataSource = viewModel
      delegate?.dataSource = viewModel
    }
  }
  
  public var dataSource: CollectionViewMultiHitsDataSource? {
    didSet {
      dataSource?.dataSource = viewModel
      collectionView.dataSource = dataSource
    }
  }
  
  public var delegate: CollectionViewMultiHitsDelegate? {
    didSet {
      delegate?.dataSource = viewModel
      collectionView.delegate = delegate
    }
  }
  
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }
  
  func reload() {
    collectionView.reloadData()
  }
  
  func scrollToTop() {
    collectionView.scrollToItem(at: IndexPath(), at: .top, animated: false)
  }
  
}
