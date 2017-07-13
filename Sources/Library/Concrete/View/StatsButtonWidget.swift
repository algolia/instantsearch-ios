//
//  StatsButtonWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 12/04/2017.
//
//

import UIKit

/// Widget that stats about Algolia search results. Built on top of `UIButton`.
@objc public class StatsButtonWidget: UIButton, StatsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var resultTemplate: String = Constants.Defaults.resultTemplate
    @IBInspectable public var errorText: String = Constants.Defaults.errorText
    @IBInspectable internal var clearText: String = Constants.Defaults.clearText
    
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
