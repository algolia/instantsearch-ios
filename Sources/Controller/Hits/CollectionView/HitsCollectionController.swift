//
//  HitsCollectionController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public typealias HitViewConfigurator<HitsView, SingleHitView, Hit> = (HitsView, Hit, IndexPath) -> SingleHitView
public typealias HitClickHandler<HitsView, Hit> = (HitsView, Hit, IndexPath) -> Void

public typealias CollectionViewCellConfigurator<Item> = HitViewConfigurator<UICollectionView, UICollectionViewCell, Item>
public typealias CollectionViewClickHandler<Item> = HitClickHandler<UICollectionView, Item>

public class HitsCollectionController<Source: HitsSource>: NSObject, HitsController {
  
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
    guard collectionView.numberOfItems(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(item: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }
  
}
