//
//  HitsViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

/// Protocol that defines the hits view input methods and propreties.
@objc public protocol HitsViewDelegate: AlgoliaIndexWidget {

    /// ViewModel associated with the WidgetV.
    var viewModel: HitsViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to reload itself.
    func reloadHits()
    
    /// Called when the viewModel instructs the widget to scroll to the top.
    func scrollTop()
    
    /// Number of hits to load per page.
    var hitsPerPage: UInt { get set }
    
    /// Whether or not the hits widget loads new entries automatically.
    var infiniteScrolling: Bool { get set }
    
    /// The minimum number of items remaining below the fold before loading more.
    var remainingItemsBeforeLoading: UInt { get set }
    
    /// Whether the show items when the query string is empty or not.
    var showItemsOnEmptyQuery: Bool { get set }
}
