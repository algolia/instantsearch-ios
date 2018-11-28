//
//  SearchControlViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation
import InstantSearchCore

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol SearchControlViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: SearchControlViewDelegate? { get set }
    
    /// search with a given query text
    func search(query: String?)
}
