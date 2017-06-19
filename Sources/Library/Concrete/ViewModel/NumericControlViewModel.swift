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
internal class NumericControlViewModel: NumericControlViewModelDelegate, SearchableViewModel {

    // MARK: - Properties

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

    var attribute: String {
        return view.attribute
    }

    // MARK: - SearchableViewModel

    var searcher: Searcher!

    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a Numeric Control before adding it to InstantSearch")
        }
        
        if searcher.params.facets == nil {
            searcher.params.facets = [attribute]
        } else if !searcher.params.facets!.contains(attribute) {
            searcher.params.facets! += [attribute]
        }
        
        if let facetStats = searcher.results?.facetStats(name: attribute) {
            view.set(min: facetStats.min, max: facetStats.max)
        }
        
        if let numeric = self.searcher.params.getNumericRefinement(name: attribute, operator: `operator`, inclusive: inclusive) {
            view.set(value: numeric.value)
        }

        view.configureView()
    }

    // MARK: - NumericControlViewModelDelegate

    weak var view: NumericControlViewDelegate!

    func updateNumeric(value: NSNumber, doSearch: Bool) {
        guard value.intValue != 0 else { return }
        self.searcher.params.updateNumericRefinement(self.attribute, self.operator, value, inclusive: inclusive)
        
        if doSearch {
            self.searcher.search()
        }
    }

    func removeNumeric(value: NSNumber) {
        self.searcher.params.removeNumericRefinement(self.attribute, self.operator, value, inclusive: inclusive)
        self.searcher.search()
    }
}

// MARK: - RefinableDelegate

extension NumericControlViewModel: RefinableDelegate {

    func onRefinementChange(numerics: [NumericRefinement]) {
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

extension NumericControlViewModel: ResultingDelegate {
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let facetStats = results?.facetStats(name: attribute) {
            view.set(min: facetStats.min, max: facetStats.max)
        }
    }

}
