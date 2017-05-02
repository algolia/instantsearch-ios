//
//  HitsCollectionWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import UIKit

@objc public class HitsCollectionWidget: UICollectionView, HitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var hitsPerPage: UInt = 20
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    internal var viewModel: HitsViewModelDelegate!
    
    public func scrollTop() {
        setContentOffset(CGPoint.zero, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
}
