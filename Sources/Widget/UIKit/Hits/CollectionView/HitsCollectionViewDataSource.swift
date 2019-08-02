//
//  HitsCollectionViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class HitsCollectionViewDataSource<DataSource: HitsSource>: NSObject, UICollectionViewDataSource {
  
  public var cellConfigurator: CollectionViewCellConfigurator<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(cellConfigurator: @escaping CollectionViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return UICollectionViewCell()
    }
    return cellConfigurator(collectionView, hit, indexPath)
  }
  
}
