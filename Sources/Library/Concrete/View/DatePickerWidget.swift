//
//  DatePickerWidger.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/05/2017.
//
//

import Foundation
import UIKit

@IBDesignable
@objc public class DatePickerWidget: UIDatePicker, NumericControlViewDelegate, AlgoliaWidget {
    
    public func set(value: NSNumber) {
        self.setDate(Date(timeIntervalSince1970: value.doubleValue), animated: false)
    }
    
    public func setup() {
        addTarget(self, action: #selector(numericFilterValueChanged), for: .valueChanged)
        
        // We add the initial value of the slider to the Search
        viewModel.updateNumeric(value: NSNumber(value: date.timeIntervalSince1970), doSearch: false)
    }
    
    func numericFilterValueChanged() {
        viewModel.updateNumeric(value: NSNumber(value: date.timeIntervalSince1970), doSearch: true)
    }
    
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
    
    @IBInspectable public var attributeName: String = ""
    
    @IBInspectable public var operation: String = "equal"
    
    // Note: can't have optional Float because IBInspectable have to be bridgable to objc
    // and value types optional cannot be bridged.
    internal var clearValue: NSNumber = 0
    
    public func getValue() -> NSNumber {
        return NSNumber(value: date.timeIntervalSince1970)
    }
    
    // TODO: Do something about this...
    public var inclusive: Bool = false
}
