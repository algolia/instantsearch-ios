//
//  SearchViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

/// Protocol that defines the hits view input methods and propreties.
@objc internal protocol SearchViewDelegate: AlgoliaWidget {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: SearchViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to update itself with a new text.
    func set(text: String, andResignFirstResponder resignFirstResponder: Bool)
}
