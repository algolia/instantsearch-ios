//
//  MultiIndexHitsCollectionViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

@available(*, deprecated, message: "Use your own UICollectionViewController conforming to HitsController protocol")
open class MultiIndexHitsCollectionViewDataSource: NSObject {
  
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
        Logger.missingHitsSourceWarning()
        return .init()
      }

      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return templateCellProvider()
      }

      return cellConfigurator(collectionView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension MultiIndexHitsCollectionViewDataSource: UICollectionViewDataSource {
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let hitsSource = hitsSource else {
      Logger.missingHitsSourceWarning()
      return 0
    }
    return hitsSource.numberOfSections()
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let hitsSource = hitsSource else {
      Logger.missingHitsSourceWarning()
      return 0
    }
    return hitsSource.numberOfHits(inSection: section)
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cellConfigurator = cellConfigurators[indexPath.section] else {
      Logger.missingCellConfiguratorWarning(forSection: indexPath.section)
      return .init()
    }
    do {
      return try cellConfigurator(collectionView, indexPath.row)
    } catch let error {
      Logger.error(error)
      return .init()
    }
  }
  
}
