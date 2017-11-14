//
//  SearchViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc internal protocol SearchViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: SearchViewDelegate! { get set }
    
    /// search with a given query text
    func search(query: String?)
}
