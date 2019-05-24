//
//  CollectionViewHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public typealias CollectionViewCellConfigurator<Item> = HitViewConfigurator<UICollectionView, UICollectionViewCell, Item>
public typealias CollectionViewClickHandler<Item> = HitClickHandler<UICollectionView, Item>

open class HitsCollectionViewDataSource<DataSource: HitsSource>: NSObject, UICollectionViewDataSource {
  
  public var cellConfigurator: CollectionViewCellConfigurator<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(cellConfigurator: @escaping CollectionViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return UICollectionViewCell()
    }
    return cellConfigurator(collectionView, hit, indexPath)
  }
  
}

open class HitsCollectionViewDelegate<DataSource: HitsSource>: NSObject, UICollectionViewDelegate {
  
  public var clickHandler: CollectionViewClickHandler<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(clickHandler: @escaping CollectionViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(collectionView, hit, indexPath)
  }

}

public class HitsCollectionController<Source: HitsSource>: NSObject, InstantSearchCore.HitsController {
  
  public let collectionView: UICollectionView
  
  public weak var hitsSource: Source?

  private var dataSource: HitsCollectionViewDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }
  
  private var delegate: HitsCollectionViewDelegate<Source>? {
    didSet {
      delegate?.hitsSource = hitsSource
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
    let indexPath = IndexPath(row: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }
  
}
