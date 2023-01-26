//
//  HitsCollectionViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 29/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
  import UIKit

  open class HitsCollectionViewController<CellConfigurator: CollectionViewCellConfigurable>: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {
    public var hitsSource: HitsInteractor<CellConfigurator.Model>?

    override open func viewDidLoad() {
      super.viewDidLoad()
      collectionView.register(CellConfigurator.Cell.self, forCellWithReuseIdentifier: CellConfigurator.cellIdentifier)
    }

    override open func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
      return hitsSource?.numberOfHits() ?? 0
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return collectionView.dequeueReusableCell(withReuseIdentifier: CellConfigurator.cellIdentifier, for: indexPath)
    }

    override open func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      guard let cell = cell as? CellConfigurator.Cell else { return }
      guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return }
      CellConfigurator(model: model, indexPath: indexPath).configure(cell)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return .zero }
      return CellConfigurator(model: model, indexPath: indexPath).cellSize
    }
  }
#endif
