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

  open override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(CellConfigurator.Cell.self, forCellWithReuseIdentifier: CellConfigurator.cellIdentifier)
  }

  open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }

  open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: CellConfigurator.cellIdentifier, for: indexPath)
  }

  open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? CellConfigurator.Cell else { return }
    guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return }
    CellConfigurator(model: model, indexPath: indexPath).configure(cell)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return .zero }
    return CellConfigurator(model: model, indexPath: indexPath).cellSize
  }

}
#endif
