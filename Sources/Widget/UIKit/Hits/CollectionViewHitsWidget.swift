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

public typealias CollectionViewCellConfigurator<Hit> = HitViewConfigurator<UICollectionView, UICollectionViewCell, Hit>
public typealias CollectionViewClickHandler<Hit> = HitClickHandler<UICollectionView, Hit>

open class CollectionViewHitsDataSource<DataSource: HitsSource>: NSObject, UICollectionViewDataSource {
  
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

open class CollectionViewHitsDelegate<DataSource: HitsSource>: NSObject, UICollectionViewDelegate {
  
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

public class CollectionViewHitsWidget<Source: HitsSource>: NSObject, HitsWidget {
  
  public let collectionView: UICollectionView
  
  public weak var hitsSource: Source?

  private var dataSource: CollectionViewHitsDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }
  
  private var delegate: CollectionViewHitsDelegate<Source>? {
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
    collectionView.scrollToItem(at: IndexPath(), at: .top, animated: false)
  }
  
}
