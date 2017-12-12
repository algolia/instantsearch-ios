//
//  RefinementMenuViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol RefinementMenuViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: RefinementMenuViewDelegate! { get set }
    
    /// Query the number of Rows to show.
    func numberOfRows() -> Int
    
    /// Query the facet to show for a row at a specific indexPath.
    func facetForRow(at indexPath: IndexPath) -> FacetValue
    
    /// Query whether facet at specific indexPath is refined or not.
    func isRefined(at indexPath: IndexPath) -> Bool
    
    /// Callback when a row at a specific indexPath is selected.
    func didSelectRow(at indexPath: IndexPath)
}
