//
//  CollectionViewMultiIndexHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class MultiIndexHitsCollectionController: NSObject, MultiIndexHitsController {
    
  public let collectionView: UICollectionView
  
  public weak var hitsSource: MultiIndexHitsSource? {
    didSet {
      dataSource?.hitsDataSource = hitsSource
      delegate?.hitsDataSource = hitsSource
    }
  }
  
  public var dataSource: MultiIndexHitsCollectionViewDataSource? {
    didSet {
      dataSource?.hitsDataSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }
  
  public var delegate: MultiIndexHitsCollectionViewDelegate? {
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
    guard collectionView.numberOfItems(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(item: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }
  
}
