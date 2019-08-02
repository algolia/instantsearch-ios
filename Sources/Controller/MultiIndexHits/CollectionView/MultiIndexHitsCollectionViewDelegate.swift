//
//  MultiIndexHitsCollectionViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class MultiIndexHitsCollectionViewDelegate: NSObject {
  
  typealias ClickHandler = (UICollectionView, Int) throws -> Void
  
  public weak var hitsDataSource: MultiIndexHitsSource?
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping CollectionViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (collectionView, row) in
      guard let hit: Hit = try self?.hitsDataSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits Interactor")
        return
      }
      clickHandler(collectionView, hit, IndexPath(item: row, section: section))
    }
  }
  
}

extension MultiIndexHitsCollectionViewDelegate: UICollectionViewDelegate {
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(collectionView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}
