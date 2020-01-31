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

public class MultiIndexHitsCollectionController: NSObject, MultiIndexHitsController, HitsCollectionViewContainer {
  
  public let collectionView: UICollectionView
  
  public var hitsCollectionView: UICollectionView {
    return collectionView
  }
  
  @available(*, deprecated, message: "Use your own UICollectionViewController conforming to HitsController protocol")
  public weak var hitsSource: MultiIndexHitsSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      delegate?.hitsSource = hitsSource
    }
  }
  
  @available(*, deprecated, message: "Use your own UICollectionViewController conforming to HitsController protocol")
  public var dataSource: MultiIndexHitsCollectionViewDataSource? {
    didSet {
      dataSource?.hitsSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }
  
  public var delegate: MultiIndexHitsCollectionViewDelegate? {
    didSet {
      delegate?.hitsSource = hitsSource
      collectionView.delegate = delegate
    }
  }
  
  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }
  
}
