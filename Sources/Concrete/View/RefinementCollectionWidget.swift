//
//  RefinementCollectionWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class RefinementCollectionWidget: UICollectionView, RefinementMenuViewDelegate, AlgoliaWidget {
    
    var viewModel: RefinementMenuViewModelDelegate!
    
    @IBInspectable public var attribute: String = ""
    @IBInspectable public var refinedFirst: Bool = true
    @IBInspectable public var `operator`: String = "or"
    @IBInspectable public var sortBy: String = "count:desc"
    @IBInspectable public var limit: Int = 10
    
    public func reloadRefinements() {
        reloadData()
    }
    
    func deselectRow(at indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
    }
}
