//
//  ButtonStatsWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 12/04/2017.
//
//

import UIKit

@IBDesignable
@objc public class ButtonStatsWidget: UIButton, StatsViewDelegate, AlgoliaWidget {
    
    var viewModel: StatsViewModelDelegate!
    
    @IBInspectable public var resultTemplate: String = "{nbHits} results"
    @IBInspectable public var clearText: String = ""
    @IBInspectable public var errorText: String = "Error in fetching results"
    
    public func set(text: String) {
        UIView.performWithoutAnimation {
            setTitle(text, for: .normal)
            layoutIfNeeded()
        }
    }
}
