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
@objcMembers public class MultiHitsTableWidget: UITableView, MultiHitsViewDelegate, AlgoliaWidget {
    
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
    
    @IBInspectable public var indices: String = Constants.Defaults.index {
        didSet {
            if indices.isEmpty {
                fatalError("indexNames cannot be empty, you need to fill it with the index names")
            }
            
            indicesArray = indices.components(separatedBy: ",")
        }
    }
    
    @IBInspectable public var variants: String = Constants.Defaults.variant {
        didSet {
            if variants.isEmpty {
                variantsArray = []
            } else {
                variantsArray = variants.components(separatedBy: ",")
            }
        }
    }
    
    public var viewModel: MultiHitsViewModelDelegate!
    
    public var indicesArray: [String] = []
    public var variantsArray: [String] = []
    public var hitsPerSectionArray: [UInt] = []
    
  public override init(frame: CGRect, style: UITableView.Style) {
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
