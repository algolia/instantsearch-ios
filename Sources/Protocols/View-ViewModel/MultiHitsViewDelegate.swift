//
//  MultiHitsViewDelegate.swift
//  InstantSearch-iOS
//
//  Created by Guy Daher on 24/11/2017.
//

import Foundation

/// Protocol that defines the hits view input methods and propreties.
@objc public protocol MultiHitsViewDelegate: AlgoliaMultiIndexWidget {
    
    /// ViewModels associated with the WidgetV.
    var viewModel: MultiHitsViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to reload itself.
    func reloadHits()
    
    /// Number of hits to load per page.
    var hitsPerSectionArray: [UInt] { get set }
    
    /// Whether the show items when the query string is empty or not.
    var showItemsOnEmptyQuery: Bool { get set }
}
