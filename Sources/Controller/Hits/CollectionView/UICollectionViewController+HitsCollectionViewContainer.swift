//
//  UICollectionViewController+HitsCollectionViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation
import UIKit

extension UICollectionViewController: HitsCollectionViewContainer {
  
  public var hitsCollectionView: UICollectionView {
    return collectionView
  }
  
}
