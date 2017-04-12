//
//  SliderWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class SliderWidget: UISlider, RefinementControlViewDelegate, AlgoliaView {
    
    public func set(value: NSNumber) {
        setValue(value.floatValue, animated: false)
    }
    
    public func registerAction() {
        addTarget(viewModel, action: #selector(viewModel.numericFilterValueChanged), for: .valueChanged)
    }
    
    public var viewModel: RefinementControlViewModelDelegate!
    
    @IBInspectable public var attributeName: String = ""
    
    @IBInspectable public var operation: String = "equal"
    
    public func getValue() -> NSNumber {
        return NSNumber(value: value)
    }
    
    // Note: can't have optional Float because IBInspectable have to be bridgable to objc
    // and value types optional cannot be bridged.
    @IBInspectable public var clearValue: NSNumber = 0
    
    // TODO: Do something about this...
    public var inclusive: Bool = false
}
