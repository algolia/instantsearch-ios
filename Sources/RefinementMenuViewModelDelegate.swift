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
    
    var view: RefinementMenuViewDelegate! { get set }
    
    func numberOfRows(in section: Int) -> Int
    func facetForRow(at indexPath: IndexPath) -> FacetValue
    func isRefined(at indexPath: IndexPath) -> Bool
    func didSelectRow(at indexPath: IndexPath)
}
