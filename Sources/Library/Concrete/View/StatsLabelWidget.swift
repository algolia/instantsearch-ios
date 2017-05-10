//
//  StatsLabelWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

@IBDesignable
@objc public class StatsLabelWidget: UILabel, StatsViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var resultTemplate: String = "{nbHits} results"
    @IBInspectable public var clearText: String = ""
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
        self.text = text
    }
}

@objc public class LabelStatsController: NSObject, StatsViewDelegate, AlgoliaWidget {
    
    var label: UILabel
    
    var viewModel: StatsViewModelDelegate
    
    public var resultTemplate: String = "{nbHits} results"
    public var clearText: String = ""
    public var errorText: String = "Error in fetching results"
    
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
