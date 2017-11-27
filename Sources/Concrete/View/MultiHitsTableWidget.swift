//
//  MultiHitsTableWidget.swift
//  InstantSearch-iOS
//
//  Created by Guy Daher on 23/11/2017.
//

import Foundation

import Foundation
import UIKit

/// Widget that displays the search results of multi index. Built over a `UITableView`.
@objc public class MultiHitsTableWidget: UITableView, MultiHitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var hitsPerSection: UInt = Constants.Defaults.hitsPerPage
    @IBInspectable public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
    
    @IBInspectable public var indexNames: String = Constants.Defaults.indexName {
        didSet {
            indexNamesArray = indexNames.components(separatedBy: ",")
        }
    }
    
    // TODO: Support different Ids as well
    @IBInspectable public var indexIds: String = Constants.Defaults.indexId {
        didSet {
            indexIdsArray = indexIds.components(separatedBy: ",")
        }
    }
    
    var viewModel: MultiHitsViewModelDelegate!
    
    public var indexNamesArray: [String] = []
    public var indexIdsArray: [String] = []
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        viewModel = MultiHitsViewModel()
        super.init(frame: frame, style: style)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = MultiHitsViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func reloadHits() {
        reloadData()
    }
}
