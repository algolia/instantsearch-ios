//
//  NumericControlViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation

/// Protocol that defines the numeric control view input methods and propreties.
@objc public protocol NumericControlViewDelegate: RefinementViewDelegate {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: NumericControlViewModelDelegate { get set }
    
    /// Configure the view when it is added in InstantSearch.
    /// Example of things that are done here are `addTarget` and set Searcher params.
    func configureView()
    
    /// Called when the viewModel instructs the widget to update itself with a new value.
    func set(value: NSNumber)
    
    /// The value to use when the clear button is clicked.
    var clearValue: NSNumber { get set }
    
    /// The Numeric Operator used for the numeric control.
    /// This is basically a String representing `NumericRefinement.Operator`.
    /// Possible values: `<`, `<=`, `==`, `!=`, `>=`, `>`.
    var `operator`: String { get set }
    
    /// Whether the refinement is inclusive (default) or exclusive (value prefixed with a dash).
    var inclusive: Bool { get set }
}
