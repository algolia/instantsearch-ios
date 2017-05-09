//
//  NumericControlViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

internal class NumericControlViewModel: NumericControlViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    var clearValue: NSNumber {
        return view.clearValue
    }
    
    var op: NumericRefinement.Operator {
        switch view.operation {
        case "lessThan", "<": return .lessThan
        case "lessThanOrEqual", "<=": return .lessThanOrEqual
        case "equal", "==": return .equal
        case "notEqual", "!=": return .notEqual
        case "greaterThanOrEqual", ">=": return .greaterThanOrEqual
        case "greaterThan", ">": return .greaterThan
        default: fatalError("No valid operation")
        }
    }

    var inclusive: Bool {
        return view.inclusive
    }

    var attributeName: String {
        return view.attributeName
    }
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        if let numeric = self.searcher.params.getNumericRefinement(name: attributeName, op: op) {
            view.set(value: numeric.value)
        }
        
        view.configureView()
    }

    // MARK: - NumericControlViewModelDelegate
    
    weak var view: NumericControlViewDelegate!
    
    func updateNumeric(value: NSNumber, doSearch: Bool) {
        numericFiltersDebouncer.call {
            self.searcher.params.updateNumericRefinement(self.attributeName, self.op, value)
            
            if doSearch {
                self.searcher.search()
            }
        }
    }
    
    func removeNumeric(value: NSNumber) {
        self.searcher.params.removeNumericRefinement(self.attributeName, self.op, value)
        self.searcher.search()
    }
}

// MARK: - RefinableDelegate

extension NumericControlViewModel: RefinableDelegate {
    var attribute: String {
        return attributeName
    }
    
    func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics {
            if numeric.op == op {
                view.set(value: numeric.value)
            }
        }
    }

}

// MARK: - ResettableDelegate

extension NumericControlViewModel: ResettableDelegate {
    func onReset() {
        view.set(value: clearValue)
    }
}
