//
//  NumericControlViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol NumericControlViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: NumericControlViewDelegate? { get set }
    
    /// Update the numeric refinement with a value.
    ///
    /// - parameter value: the new numeric value to update.
    /// - parameter doSearch: whether to do a new search or not.
    func updateNumeric(value: NSNumber, doSearch: Bool)
    
    /// Remove the numeric refinement.
    ///
    /// - parameter value: the numeric value to remove.
    func removeNumeric(value: NSNumber)
}
