//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class RefinementTableWidget: UITableView, RefinementMenuViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attribute: String = ""
    @IBInspectable public var refinedFirst: Bool = true
    @IBInspectable public var `operator`: String = "or"
    @IBInspectable public var sortBy: String = "count:desc"
    @IBInspectable public var limit: Int = 10
    
    var viewModel: RefinementMenuViewModelDelegate
    
    public override init(frame: CGRect, style: UITableViewStyle) {
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
    
    func deselectRow(at indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
}
