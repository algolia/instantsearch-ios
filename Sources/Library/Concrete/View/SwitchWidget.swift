//
//  SwitchWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class SwitchWidget: UISwitch, FacetControlViewDelegate, AlgoliaWidget {
    
    // TODO: Need to override for TwoValuesSwitch
    open func set(value: String) {
        print("HERE \(value)")
        setOn(value == valueOn, animated: true)
    }
    
    open func setup() {
        fatalError("Cannot use SwitchWidget by itself. Need to use either OneValueSwitchWidget, or TwoValuesSwitchWidget")
    }
    
    var viewModel: FacetControlViewModelDelegate
    
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
    
    @IBInspectable public var attributeName: String = ""
    @IBInspectable public var valueOn: String = "true"
    
    internal var operation: String = "equal"
    
    internal var clearValue: NSNumber = NSNumber(value: false)
    
    open func getValue() -> String {
        return valueOn
    }
    
    // TODO: Do something about this...
    public var inclusive: Bool = false
}
