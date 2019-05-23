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
  
  private typealias CellConfigurator = (UICollectionView, Int) throws -> UICollectionViewCell
  
  public weak var hitsDataSource: MultiHitsSource? {
    didSet {
      cellConfigurators.removeAll()
    }
  }
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping CollectionViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (collectionView, row) in
      guard let dataSource = self?.hitsDataSource else { return UICollectionViewCell() }
      guard let hit: Hit = try dataSource.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits ViewModel")
        return UICollectionViewCell()
      }
      return cellConfigurator(collectionView, hit, IndexPath(item: row, section: section))
    }
  }
  
}

extension CollectionViewMultiHitsDataSource: UICollectionViewDataSource {
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let numberOfSections = hitsDataSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let numberOfRows = hitsDataSource?.numberOfHits(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(collectionView, indexPath.row) ?? UICollectionViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

open class CollectionViewMultiHitsDelegate: NSObject {
  
  typealias ClickHandler = (UICollectionView, Int) throws -> Void
  
  public weak var hitsDataSource: MultiHitsSource? {
    didSet {
      clickHandlers.removeAll()
    }
  }
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping CollectionViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (collectionView, row) in
      guard let hit: Hit = try self?.hitsDataSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits ViewModel")
        return
      }
      clickHandler(collectionView, hit, IndexPath(item: row, section: section))
    }
  }
  
}

extension CollectionViewMultiHitsDelegate: UICollectionViewDelegate {
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(collectionView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

public class CollectionViewMultiHitsWidget: NSObject, InstantSearchCore.MultiHitsController {
  
  public typealias SingleHitView = UITableViewCell
  
  public let collectionView: UICollectionView
  
  public weak var hitsSource: MultiHitsSource? {
    didSet {
      dataSource?.hitsDataSource = hitsSource
      delegate?.hitsDataSource = hitsSource
    }
  }
  
  public var dataSource: CollectionViewMultiHitsDataSource? {
    didSet {
      dataSource?.hitsDataSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }
  
  public var delegate: CollectionViewMultiHitsDelegate? {
    didSet {
      delegate?.hitsDataSource = hitsSource
      collectionView.delegate = delegate
    }
  }
  
  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }
  
  public func reload() {
    collectionView.reloadData()
  }
  
  public func scrollToTop() {
    collectionView.scrollToItem(at: IndexPath(), at: .top, animated: false)
  }
  
}
