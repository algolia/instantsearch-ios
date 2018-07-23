//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

/// Widget that displays your search results. Built over a `UITableView`.
/// + Note: This is best used with a HitsController (through composition) or a HitsTableViewController (through inheritance).
@objcMembers public class HitsTableWidget: UITableView, HitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var hitsPerPage: UInt = Constants.Defaults.hitsPerPage
    @IBInspectable public var infiniteScrolling: Bool = Constants.Defaults.infiniteScrolling
    @IBInspectable public var remainingItemsBeforeLoading: UInt = Constants.Defaults.remainingItemsBeforeLoading
    @IBInspectable public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: HitsViewModelDelegate
    
  public override init(frame: CGRect, style: UITableView.Style) {
        viewModel = HitsViewModel()
        super.init(frame: frame, style: style)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = HitsViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func scrollTop() {
        scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
}
