//
//  UICollectionViewController+HitsCollectionViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation

#if canImport(UIKit)
import UIKit

extension UICollectionViewController: HitsCollectionViewContainer {
  
  public var hitsCollectionView: UICollectionView {
    return collectionView
  }
  
}
#endif
