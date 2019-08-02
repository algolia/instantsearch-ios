//
//  MultiIndexHitsCollectionViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class MultiIndexHitsCollectionViewDataSource: NSObject {
  
  private typealias CellConfigurator = (UICollectionView, Int) throws -> UICollectionViewCell
  
  public weak var hitsDataSource: MultiIndexHitsSource?
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping CollectionViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (collectionView, row) in
      guard let dataSource = self?.hitsDataSource else { return UICollectionViewCell() }
      guard let hit: Hit = try dataSource.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits Interactor")
        return UICollectionViewCell()
      }
      return cellConfigurator(collectionView, hit, IndexPath(item: row, section: section))
    }
  }
  
}

extension MultiIndexHitsCollectionViewDataSource: UICollectionViewDataSource {
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let numberOfSections = hitsDataSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let numberOfRows = hitsDataSource?.numberOfHits(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(collectionView, indexPath.row) ?? UICollectionViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}
