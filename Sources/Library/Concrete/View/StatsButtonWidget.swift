//
//  StatsButtonWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 12/04/2017.
//
//

import UIKit

@IBDesignable
@objc public class StatsButtonWidget: UIButton, StatsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var resultTemplate: String = "{nbHits} results"
    @IBInspectable internal var clearText: String = ""
    @IBInspectable public var errorText: String = "Error in fetching results"
    
    var viewModel: StatsViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = StatsViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = StatsViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func set(text: String) {
        UIView.performWithoutAnimation {
            setTitle(text, for: .normal)
            layoutIfNeeded()
        }
    }
}
