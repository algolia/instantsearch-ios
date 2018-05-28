//
//  SwitchWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

/// + Warning: Do Not use this class. Only use `OneValueSwitchWidget` or `TwoValuesSwitchWidget`.
@objcMembers public class SwitchWidget: UISwitch, FacetControlViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    /// Value used for facet when the Switch is on
    @IBInspectable public var valueOn: String = Constants.Defaults.valueOn
    @IBInspectable public var inclusive: Bool = Constants.Defaults.inclusive
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: FacetControlViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = FacetControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = FacetControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    open func set(value: String) {
        setOn(value == valueOn, animated: true)
    }
    
    open func configureView() {
        fatalError("Cannot use SwitchWidget by itself. Need to use either OneValueSwitchWidget, or TwoValuesSwitchWidget")
    }
}
