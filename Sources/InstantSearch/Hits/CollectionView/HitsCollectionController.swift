//
//  HitsCollectionController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public typealias HitViewConfigurator<HitsView, SingleHitView, Hit> = (HitsView, Hit, IndexPath) -> SingleHitView
public typealias HitClickHandler<HitsView, Hit> = (HitsView, Hit, IndexPath) -> Void

public typealias CollectionViewCellConfigurator<Item> = HitViewConfigurator<UICollectionView, UICollectionViewCell, Item>
public typealias CollectionViewClickHandler<Item> = HitClickHandler<UICollectionView, Item>

@available(*, unavailable, message: "Use your own UICollectionViewController conforming to HitsController protocol")
public class HitsCollectionController<Source: HitsSource>: NSObject, HitsController, HitsCollectionViewContainer {

  public let collectionView: UICollectionView

  public var hitsCollectionView: UICollectionView {
    return collectionView
  }

  public weak var hitsSource: Source?

  public var dataSource: HitsCollectionViewDataSource<Source>? {
    didSet {
      dataSource?.hitsSource = hitsSource
      collectionView.dataSource = dataSource
    }
  }

  public var delegate: HitsCollectionViewDelegate<Source>? {
    didSet {
      delegate?.hitsSource = hitsSource
      collectionView.delegate = delegate
    }
  }

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }

  // These functions are implemented in the protocol extension, but should be there till
  // compiler bug is fixed

  public func reload() {
    hitsCollectionView.reloadData()
  }

  public func scrollToTop() {
    guard hitsCollectionView.numberOfItems(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(item: 0, section: 0)
    hitsCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }

}
#endif
