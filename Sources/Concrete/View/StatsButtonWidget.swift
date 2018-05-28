//
//  StatsButtonWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 12/04/2017.
//
//

import UIKit

/// Widget that stats about Algolia search results. Built on top of `UIButton`.
@objcMembers public class StatsButtonWidget: UIButton, StatsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var resultTemplate: String = Constants.Defaults.resultTemplate
    @IBInspectable public var errorText: String = Constants.Defaults.errorText
    @IBInspectable public var clearText: String = Constants.Defaults.clearText
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: StatsViewModelDelegate
    
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
