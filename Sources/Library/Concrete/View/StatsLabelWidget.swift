//
//  StatsLabelWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

/// Widget that stats about Algolia search results. Built on top of `UILabel`.
@objc public class StatsLabelWidget: UILabel, StatsViewDelegate, AlgoliaWidget {
    
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
        self.text = text
    }
}

@objc internal class StatsLabelController: NSObject, StatsViewDelegate, AlgoliaWidget {
    
    var label: UILabel
    
    var viewModel: StatsViewModelDelegate
    
    public var resultTemplate: String = Constants.Defaults.resultTemplate
    public var errorText: String = Constants.Defaults.errorText
    internal var clearText: String = Constants.Defaults.clearText
    
    public init(label: UILabel) {
        self.label = label
        viewModel = StatsViewModel()
        super.init()
        viewModel.view = self
    }
    
    public func set(text: String) {
        label.text = text
    }
}
