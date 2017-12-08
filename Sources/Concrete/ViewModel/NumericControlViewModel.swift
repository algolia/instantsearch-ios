//
//  NumericControlViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: NumericControlViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, RefinableDelegate, ResettableDelegate.
public class NumericControlViewModel: NumericControlViewModelDelegate, SearchableIndexViewModel {

    // MARK: - Properties
    public var searcherId: SearcherId {
        return SearcherId(index:  view.index, variant: view.variant)
    }
    
    var clearValue: NSNumber {
        return view.clearValue
    }

    var `operator`: NumericRefinement.Operator {
        switch view.operator {
        case "lessThan", "<": return .lessThan
        case "lessThanOrEqual", "<=": return .lessThanOrEqual
        case "equal", "==": return .equal
        case "notEqual", "!=": return .notEqual
        case "greaterThanOrEqual", ">=": return .greaterThanOrEqual
        case "greaterThan", ">": return .greaterThan
        default: fatalError("No valid operator for the numeric control. Use something like < or >=")
        }
    }

    var inclusive: Bool {
        return view.inclusive
    }

    public var attribute: String {
        return view.attribute
    }

    // MARK: - SearchableViewModel

    var searcher: Searcher!

    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a Numeric Control before adding it to InstantSearch")
        }
        
        if let numeric = self.searcher.params.getNumericRefinement(name: attribute, operator: `operator`, inclusive: inclusive) {
            view.set(value: numeric.value)
        }

        view.configureView()
    }

    // MARK: - NumericControlViewModelDelegate

    public weak var view: NumericControlViewDelegate!
    
    init() { }
    
    public init(view: NumericControlViewDelegate) {
        self.view = view
    }

    public func updateNumeric(value: NSNumber, doSearch: Bool) {
        
        self.searcher.params.updateNumericRefinement(self.attribute, self.operator, value, inclusive: inclusive)
        
        if doSearch {
            self.searcher.search()
        }
    }

    public func removeNumeric(value: NSNumber) {
        self.searcher.params.removeNumericRefinement(self.attribute, self.operator, value, inclusive: inclusive)
        self.searcher.search()
    }
}

// MARK: - RefinableDelegate

extension NumericControlViewModel: RefinableDelegate {

    public func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics where numeric.op == `operator` && numeric.inclusive == inclusive {
            view.set(value: numeric.value)
        }
    }

}

// MARK: - ResettableDelegate

extension NumericControlViewModel: ResettableDelegate {
    func onReset() {
        view.set(value: clearValue)
    }
}
