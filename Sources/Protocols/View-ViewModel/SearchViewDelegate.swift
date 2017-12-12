//
//  SearchControlViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

/// Protocol that defines the hits view input methods and propreties.
@objc public protocol SearchControlViewDelegate: AlgoliaIndexWidget {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: SearchControlViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to update itself with a new text.
    func set(text: String, andResignFirstResponder resignFirstResponder: Bool)
}
