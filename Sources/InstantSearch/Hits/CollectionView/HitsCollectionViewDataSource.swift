//
//  HitsCollectionViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(*, unavailable, message: "Use your own UICollectionViewController conforming to HitsController protocol")
open class HitsCollectionViewDataSource<DataSource: HitsSource>: NSObject, UICollectionViewDataSource {

  public var cellConfigurator: CollectionViewCellConfigurator<DataSource.Record>
  public var templateCellProvider: () -> UICollectionViewCell
  public weak var hitsSource: DataSource?

  public init(cellConfigurator: @escaping CollectionViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
    self.templateCellProvider = { return .init() }
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return 0
    }

    return hitsSource.numberOfHits()

  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return templateCellProvider()
    }

    guard let hit = hitsSource.hit(atIndex: indexPath.row) else {
      return templateCellProvider()
    }

    return cellConfigurator(collectionView, hit, indexPath)

  }

}
#endif
