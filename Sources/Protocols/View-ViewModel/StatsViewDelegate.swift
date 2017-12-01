//
//  StatsViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 10/04/2017.
//
//

import Foundation

/// Protocol that defines the stats view input methods and propreties.
@objc public protocol StatsViewDelegate: AlgoliaIndexWidget {
    
    /// ViewModel associated with the WidgetV.
    var viewModel: StatsViewModelDelegate! { get set }
    
    /// Called when the viewModel instructs the widget to update itself with a new text.
    func set(text: String)
    
    /// Template used for the stats widget.
    /// Possible placeholders: `{hitsPerPage}`, `{processingTimeMS}`, `{nbHits}`, `{nbPages}`, `{page}`, `{query}`.
    var resultTemplate: String { get set }
    
    /// Text displayed when an error occurs after an Algolia search.
    var errorText: String { get set }
    
    /// Text displayed when a clear/reset has been clicked.
    var clearText: String { get set }
}
