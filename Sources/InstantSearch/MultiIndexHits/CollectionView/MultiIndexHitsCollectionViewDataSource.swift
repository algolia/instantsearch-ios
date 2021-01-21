//
//  MultiIndexHitsCollectionViewDataSource.swift
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
open class MultiIndexHitsCollectionViewDataSource: NSObject, UICollectionViewDataSource {

  private typealias CellConfigurator = (UICollectionView, Int) throws -> UICollectionViewCell

  public weak var hitsSource: MultiIndexHitsSource?

  private var cellConfigurators: [Int: CellConfigurator]

  override init() {
    cellConfigurators = [:]
    super.init()
  }

  public func setCellConfigurator<Hit: Codable>(forSection section: Int,
                                                templateCellProvider: @escaping () -> UICollectionViewCell = { return .init() },
                                                _ cellConfigurator: @escaping CollectionViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (collectionView, row) in

      guard let hitsSource = self?.hitsSource else {
        InstantSearchLogger.missingHitsSourceWarning()
        return .init()
      }

      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return templateCellProvider()
      }

      return cellConfigurator(collectionView, hit, IndexPath(row: row, section: section))
    }
  }

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return 0
    }
    return hitsSource.numberOfSections()
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return 0
    }
    return hitsSource.numberOfHits(inSection: section)
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cellConfigurator = cellConfigurators[indexPath.section] else {
      InstantSearchLogger.missingCellConfiguratorWarning(forSection: indexPath.section)
      return .init()
    }
    do {
      return try cellConfigurator(collectionView, indexPath.row)
    } catch let underlyingError {
      InstantSearchLogger.error(underlyingError)
      return .init()
    }
  }

}
#endif
