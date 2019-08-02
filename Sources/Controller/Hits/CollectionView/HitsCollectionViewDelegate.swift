//
//  HitsCollectionViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class HitsCollectionViewDelegate<DataSource: HitsSource>: NSObject, UICollectionViewDelegate {
  
  public var clickHandler: CollectionViewClickHandler<DataSource.Record>
  public weak var hitsSource: DataSource?
  
  public init(clickHandler: @escaping CollectionViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(collectionView, hit, indexPath)
  }
  
}
