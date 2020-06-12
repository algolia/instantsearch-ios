//
//  UICollectionView+Convenience.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 20/01/2020.
//

import Foundation

#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public extension UICollectionView {

  func scrollToFirstNonEmptySection() {
    (0..<numberOfSections)
      .first(where: { numberOfItems(inSection: $0) > 0 })
      .flatMap { IndexPath(item: 0, section: $0) }
      .flatMap { scrollToItem(at: $0, at: .top, animated: false) }

  }

}
#endif
