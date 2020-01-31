//
//  MultiIndexHitsCollectionViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

@available(*, deprecated, message: "Use your own UICollectionViewController conforming to HitsController protocol")
open class MultiIndexHitsCollectionViewDelegate: NSObject {
  
  typealias ClickHandler = (UICollectionView, Int) throws -> Void
  
  public weak var hitsSource: MultiIndexHitsSource?
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping CollectionViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (collectionView, row) in
      guard let delegate = self else { return }
      
      guard let hitsSource = delegate.hitsSource else {
        Logger.missingHitsSourceWarning()
        return
      }
      
      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return
      }
      
      clickHandler(collectionView, hit, IndexPath(item: row, section: section))
      
    }
  }
  
}

extension MultiIndexHitsCollectionViewDelegate: UICollectionViewDelegate {
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let clickHandler = clickHandlers[indexPath.section] else {
      Logger.missingClickHandlerWarning(forSection: indexPath.section)
      return
    }
    do {
      try clickHandler(collectionView, indexPath.row)
    } catch let error {
      Logger.error(error)
    }
  }
  
}
