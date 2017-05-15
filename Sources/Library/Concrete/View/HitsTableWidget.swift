//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@objc public class HitsTableWidget: UITableView, HitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var hitsPerPage: UInt = Constants.Defaults.hitsPerPage
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    var viewModel: HitsViewModelDelegate
    
    public override init(frame: CGRect, style: UITableViewStyle) {
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
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
}
