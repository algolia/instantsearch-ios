//
//  RefinementControlViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

public class RefinementControlViewModel: RefinementControlViewModelDelegate, SearchableViewModel {
    
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
    
    public var searcher: Searcher! {
        didSet {
            if let numeric = self.searcher.params.getNumericRefinement(name: attributeName, op: op) {
                view.set(value: numeric.value)
            }
            
            view.registerAction()
        }
    }

    // MARK: - RefinementControlViewModelDelegate
    
    public weak var view: RefinementControlViewDelegate!
    
    @objc public func numericFilterValueChanged() {
        numericFiltersDebouncer.call {
            self.searcher.params.updateNumericRefinement(self.attributeName, self.op, self.view.getValue())
            self.searcher.search()
        }
    }
}

// MARK: - RefinableDelegate

extension RefinementControlViewModel: RefinableDelegate {
    @objc public func getAttributeName() -> String {
        // TODO: Error handling
        //        if view.attributeName.isEmpty { throw "a control refinement does not have an attribute name specified" }
        return attributeName
    }
    
    @objc public func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics {
            if numeric.op == op {
                view.set(value: numeric.value)
            }
        }
    }
}

// MARK: - ResettableDelegate

extension RefinementControlViewModel: ResettableDelegate {
    @objc public func onReset() {
        view.set(value: clearValue)
    }
}


extension SearchParameters {
    
    func getNumericRefinement(name filterName: String, op: NumericRefinement.Operator, inclusive: Bool = true) -> NumericRefinement? {
        return numericRefinements[filterName]?.first(where: { $0.op == op && $0.inclusive == inclusive})
    }
}
