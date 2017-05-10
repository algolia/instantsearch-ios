//
//  StepperWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class StepperWidget: UIStepper, NumericControlViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attributeName: String = ""
    @IBInspectable public var operation: String = "<"
    
    // Note: can't have optional Float because IBInspectable have to be bridgable to objc
    // and value types optional cannot be bridged.
    internal var clearValue: NSNumber = 0
    
    // TODO: Do something about this...
    public var inclusive: Bool = false
    
    var viewModel: NumericControlViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = NumericControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = NumericControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func set(value: NSNumber) {
        self.value = value.doubleValue
    }
    
    public func configureView() {
        addTarget(self, action: #selector(numericFilterValueChanged), for: .valueChanged)
        
        // We add the initial value of the slider to the Search
        viewModel.updateNumeric(value: NSNumber(value: value), doSearch: false)
    }
    
    func numericFilterValueChanged() {
        viewModel.updateNumeric(value: NSNumber(value: value), doSearch: true)
    }
}
