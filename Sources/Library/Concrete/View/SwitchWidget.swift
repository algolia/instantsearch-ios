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
@objc public class SwitchWidget: UISwitch, RefinementControlViewDelegate, AlgoliaWidget {
    
    public func set(value: NSNumber) {
        setOn(value.boolValue, animated: false)
    }
    
    open func setup() {
        fatalError("Cannot use SwitchWidget by itself. Need to use either OneValueSwitchWidget, or TwoValuesSwitchWidget")
    }
    
    var viewModel: RefinementControlViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = RefinementControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = RefinementControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    @IBInspectable public var attributeName: String = ""
    
    internal var operation: String = "equal"
    
    internal var clearValue: NSNumber = NSNumber(value: false)
    
    public func getValue() -> NSNumber {
        return NSNumber(value: isOn)
    }
    
    // TODO: Do something about this...
    public var inclusive: Bool = false
}
