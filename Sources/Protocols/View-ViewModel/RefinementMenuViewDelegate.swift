//
//  RefinementMenuViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation

/// Protocol that defines the refinement menu view input methods and propreties.
@objc public protocol RefinementMenuViewDelegate: RefinementViewDelegate {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: RefinementMenuViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to reload itself.
    func reloadRefinements()
    
    /// Called when the viewModel instructs the widget to delesect a row.
    func deselectRow(at: IndexPath)
    
    /// Whether the refined values are shown first (default) or not.
    var refinedFirst: Bool { get set }
    
    /// The way to sort the RefinementMenu.
    /// This is basically a String representing `TransformRefinementList`.
    /// Possible values are `count:asc`, `count:desc` (default), `name:asc`, `name:desc`
    var sortBy: String { get set }
    
    /// The refinement operator.
    /// Possible values: `or`, `and`.
    var `operator`: String { get set }
    
    /// Number of facets to show in the menu.
    var limit: Int { get set }
}
