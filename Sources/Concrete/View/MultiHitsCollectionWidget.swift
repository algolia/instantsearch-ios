//
//  MultiHitsTablWidget.swift
//  InstantSearch-iOS
//
//  Created by Guy Daher on 28/11/2017.
//

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
@objc public class MultiHitsCollectionWidget: UICollectionView, MultiHitsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery
    
    @IBInspectable public var hitsPerSection: String = String(Constants.Defaults.hitsPerPage) {
        didSet {
            hitsPerSectionArray = hitsPerSection.components(separatedBy: ",").map({ (hitsPerSection) in
                guard let hitsPerSectionUInt = UInt(hitsPerSection) else {
                    fatalError("hitsPerSection should be comma seperated numbers")
                }
                
                return hitsPerSectionUInt
                }
            )
        }
    }
    
    @IBInspectable public var indexNames: String = Constants.Defaults.indexName {
        didSet {
            indexNamesArray = indexNames.components(separatedBy: ",")
        }
    }
    
    @IBInspectable public var indexIds: String = Constants.Defaults.indexId {
        didSet {
            if indexIds.isEmpty {
                indexIdsArray = []
            } else {
                indexIdsArray = indexIds.components(separatedBy: ",")
            }
        }
    }
    
    var viewModel: MultiHitsViewModelDelegate!
    
    public var indexNamesArray: [String] = []
    public var indexIdsArray: [String] = []
    public var hitsPerSectionArray: [UInt] = []
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = MultiHitsViewModel()
        super.init(frame: frame, collectionViewLayout: layout)
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
