//
//  StatsLabelWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

/// Widget that stats about Algolia search results. Built on top of `UILabel`.
@objcMembers public class StatsLabelWidget: UILabel, StatsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var resultTemplate: String = Constants.Defaults.resultTemplate
    @IBInspectable public var errorText: String = Constants.Defaults.errorText
    @IBInspectable public var clearText: String = Constants.Defaults.clearText
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: StatsViewModelDelegate
    
    @objc public override init(frame: CGRect) {
        viewModel = StatsViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        viewModel = StatsViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func set(text: String) {
        self.text = text
    }
}

@objc internal class StatsLabelController: NSObject, StatsViewDelegate, AlgoliaWidget {
    
    var label: UILabel
    
    var viewModel: StatsViewModelDelegate
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var resultTemplate: String = Constants.Defaults.resultTemplate
    public var errorText: String = Constants.Defaults.errorText
    internal var clearText: String = Constants.Defaults.clearText
    
    @objc public init(label: UILabel) {
        self.label = label
        viewModel = StatsViewModel()
        super.init()
        viewModel.view = self
    }
    
    public func set(text: String) {
        label.text = text
    }
}
