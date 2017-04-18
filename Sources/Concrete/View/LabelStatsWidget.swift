//
//  LabelStatsWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

@IBDesignable
@objc public class LabelStatsWidget: UILabel, StatsViewDelegate, AlgoliaView {
    
    var viewModel: StatsViewModelDelegate!
    
    @IBInspectable public var resultTemplate: String = "{nbHits} results"
    @IBInspectable public var clearText: String = ""
    @IBInspectable public var errorText: String = "Error in fetching results"
    
    public func set(text: String) {
        self.text = text
    }
}
