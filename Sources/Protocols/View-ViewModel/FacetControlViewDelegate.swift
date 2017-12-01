//
//  File.swift
//  InstantSearch
//
//  Created by Guy Daher on 04/05/2017.
//
//

import Foundation

/// Protocol that defines the facet control view input methods and propreties.
@objc public protocol FacetControlViewDelegate: RefinementViewDelegate {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: FacetControlViewModelDelegate { get set }
    
    /// Configure the view when it is added in InstantSearch.
    /// Example of things that are done here are `addTarget` and set Searcher params.
    func configureView()
    
    /// Called when the viewModel instructs the widget to update itself with a new value.
    func set(value: String)
    
    /// Whether the refinement is inclusive (default) or exclusive (value prefixed with a dash).
    var inclusive: Bool { get set }
}
