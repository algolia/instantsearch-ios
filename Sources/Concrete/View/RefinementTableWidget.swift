//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

/// Widget that displays facet values for an attribute and lets the user filter the results using these values. Built over a `UITableView`.
/// + Note: This is best used with a RefinementController (through composition) or a RefinementTableViewController (through inheritance).
/// + Remark: You must assign a value to the `attribute` property since the refinement table cannot operate without one.
/// A FatalError will be thrown if you don't specify anything.
@objcMembers public class RefinementTableWidget: UITableView, RefinementMenuViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    @IBInspectable public var refinedFirst: Bool = Constants.Defaults.refinedFirst
    
    /// operator used for the refinementList
    @IBInspectable public var `operator`: String = Constants.Defaults.operatorRefinement
    @IBInspectable public var sortBy: String = Constants.Defaults.sortBy
    @IBInspectable public var limit: Int = Constants.Defaults.limit
    @IBInspectable public var areMultipleSelectionsAllowed: Bool = Constants.Defaults.areMultipleSelectionsAllowed
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: RefinementMenuViewModelDelegate
    
  public override init(frame: CGRect, style: UITableView.Style) {
        viewModel = RefinementMenuViewModel()
        super.init(frame: frame, style: style)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = RefinementMenuViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func reloadRefinements() {
        reloadData()
    }
    
    public func deselectRow(at indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
}
