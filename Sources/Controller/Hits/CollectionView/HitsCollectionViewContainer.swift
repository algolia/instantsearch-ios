//
//  HitsCollectionViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation
import UIKit

public protocol HitsCollectionViewContainer {
  
  var hitsCollectionView: UICollectionView { get }
  
}

public extension HitsController where Self: HitsCollectionViewContainer {
  
  func reload() {
    hitsCollectionView.reloadData()
  }
  
  func scrollToTop() {
    guard hitsCollectionView.numberOfItems(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(row: 0, section: 0)
    self.hitsCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }
  
}

public extension MultiIndexHitsController where Self: HitsCollectionViewContainer {
  
  func reload() {
    hitsCollectionView.reloadData()
  }
  
  func scrollToTop() {
    guard hitsCollectionView.numberOfItems(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(item: 0, section: 0)
    hitsCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
  }
  
}
