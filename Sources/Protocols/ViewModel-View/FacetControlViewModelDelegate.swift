//
//  FacetControlViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 04/05/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol FacetControlViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: FacetControlViewDelegate? { get set }
    
    /// Add a facet value.
    ///
    /// - parameter value: the facet value to add.
    /// - parameter doSearch: whether to do a new search or not.
    func addFacet(value: String, doSearch: Bool)
    
    /// Update the facet refinement with a value.
    ///
    /// - parameter oldValue: the old Value to remove.
    /// - parameter newValie: the new value to add.
    /// - parameter doSearch: whether to do a new search or not.
    func updateFacet(oldValue: String, newValue: String, doSearch: Bool)
    
    /// Remove a Facet refinement.
    ///
    /// - parameter value: the new numeric value to update.
    func removeFacet(value: String)
}
