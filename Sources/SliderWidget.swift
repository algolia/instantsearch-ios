//
//  SliderWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

@IBDesignable
@objc class SliderWidget: UISlider, RefinementControlWidget {
    
    private var searcher: Searcher?
    var valueLabel: UILabel?
    
    @IBInspectable public var attributeName: String!
    @IBInspectable public var operation: String! {
        didSet {
            switch operation {
                case "lessThan": op = .lessThan
                case "lessThanOrEqual": op = .lessThanOrEqual
                case "equal": op = .equal
                case "notEqual": op = .notEqual
                case "greaterThanOrEqual": op = .greaterThanOrEqual
                case "greaterThan": op = .greaterThan
                default: fatalError("No valid operation")
            }
        }
    }
    public var op: NumericRefinement.Operator!
    public var inclusive: Bool!
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
        if let numeric = self.searcher?.params.getNumericRefinement(name: attributeName, op: op) {
            setValue(numeric.value.floatValue, animated: false)
            // TODO: Offer customisation and reevaluate if label is best choice
            valueLabel?.text = "\(numeric.value)"
        }
    }
    
    @objc func registerValueChangedAction() {
        addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc internal func numericFilterValueChanged(sender: SliderWidget) {
        numericFiltersDebouncer.call {
            self.searcher?.params.updateNumericRefinement(self.attributeName, self.op, NSNumber(value: sender.value))
            self.searcher?.search()
        }
    }
    
    @objc func getAttributeName() -> String {
        return attributeName
    }
    
    @objc func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics {
            if numeric.op == op {
                setValue(numeric.value.floatValue, animated: false)
                 // TODO: Offer customisation and reevaluate if label is best choice
                valueLabel?.text = "\(numeric.value)"
            }
        }
    }
    
    @objc func onReset() {
        setValue(minimumValue, animated: false)
        // TODO: Is minimum the right choice? maybe we want max to be default! think about it...
        valueLabel?.text = "\(minimumValue)"
    }
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        
    }
}

extension SearchParameters {
    
    func getNumericRefinement(name filterName: String, op: NumericRefinement.Operator, inclusive: Bool = true) -> NumericRefinement? {
        return numericRefinements[filterName]?.first(where: { $0.op == op && $0.inclusive == inclusive})
    }
}
