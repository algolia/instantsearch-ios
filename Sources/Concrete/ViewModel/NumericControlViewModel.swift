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
@objcMembers public class NumericControlViewModel: NSObject, NumericControlViewModelDelegate, SearchableIndexViewModel {

    // MARK: - Properties
    private var _searcherId: SearcherId?

    public var searcherId: SearcherId {
        set {
            _searcherId = newValue
        } get {
            if let strongSearcherId = _searcherId { return strongSearcherId}

            if let view = view {
                return SearcherId(index: view.index, variant: view.variant)
            } else {
                print("ERROR - ViewModel not associated to any searcherId or View, so it cannot operate")
                return SearcherId(index: "")
            }
        }
    }

    private var _operator: NumericRefinement.Operator?

    var `operator`: NumericRefinement.Operator {
        set {
            _operator = newValue
        }
        get {
            if let strongOperator = _operator { return strongOperator }
            switch view?.operator {
            case "lessThan", "<": return .lessThan
            case "lessThanOrEqual", "<=": return .lessThanOrEqual
            case "equal", "==": return .equal
            case "notEqual", "!=": return .notEqual
            case "greaterThanOrEqual", ">=": return .greaterThanOrEqual
            case "greaterThan", ">": return .greaterThan
            default: fatalError("No valid operator for the numeric control. Use something like < or >=")
            }
        }
    }

    private var _inclusive: Bool?

    public var inclusive: Bool {
        set {
            _inclusive = newValue
        } get {
            return _inclusive ?? view?.inclusive ?? Constants.Defaults.inclusive
        }
    }

    private var _attribute: String?

    public var attribute: String {
        set {
            _attribute = newValue
        } get {
            return _attribute ?? view?.attribute ?? Constants.Defaults.attribute
        }
    }

    // MARK: - SearchableViewModel

    var searcher: Searcher!

    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a Numeric Control before adding it to InstantSearch")
        }
        
        if let numeric = self.searcher.params.getNumericRefinement(name: attribute, operator: `operator`, inclusive: inclusive) {
            view?.set(value: numeric.value)
        }

        view?.configureView()
    }

    // MARK: - NumericControlViewModelDelegate

    public weak var view: NumericControlViewDelegate?
    
    override init() { }
    
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
            view?.set(value: numeric.value)
        }
    }

}
