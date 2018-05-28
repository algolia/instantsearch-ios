//
//  HitsCollectionWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import UIKit

/// Widget that displays your search results. Built over a `UICollectionView`.
/// + Note: This is best used with a HitsController (through composition) or a HitsCollectionViewController (through inheritance).
@objcMembers public class HitsCollectionWidget: UICollectionView, HitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var hitsPerPage: UInt = Constants.Defaults.hitsPerPage
    @IBInspectable public var infiniteScrolling: Bool = Constants.Defaults.infiniteScrolling
    @IBInspectable public var remainingItemsBeforeLoading: UInt = Constants.Defaults.remainingItemsBeforeLoading
    @IBInspectable public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: HitsViewModelDelegate
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = HitsViewModel()
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = HitsViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func scrollTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
}
