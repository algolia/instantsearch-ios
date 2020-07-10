//
//  CollectionViewMultiIndexHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable weak_delegate

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(*, unavailable, message: "Use your own UICollectionViewController conforming to MultiIndexHitsController protocol")
public class MultiIndexHitsCollectionController: NSObject, MultiIndexHitsController, HitsCollectionViewContainer {

  public let collectionView: UICollectionView

  public var hitsCollectionView: UICollectionView {
    return collectionView
  }

  public weak var hitsSource: MultiIndexHitsSource?

  public var dataSource: MultiIndexHitsCollectionViewDataSource?

  public var delegate: MultiIndexHitsCollectionViewDelegate?

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }

}
#endif
